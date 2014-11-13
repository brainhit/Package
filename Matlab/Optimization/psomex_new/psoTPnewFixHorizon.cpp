#include "mex.h"

#include <iostream>
#include <time.h>
#include "mtrand.h"
#include <math.h>

using namespace std;


////////////////////// define constant number
const float PI=3.14159265359;
const int maxDim = 100;
const int maxNP = 200;

////////////////////// define struct
// define cell parameter
struct cellParaStruct{
	int cellNo; // cell number
	float cellSpeed[10]; // cell speed
	float cellA[10]; // cell angular changing rate
	float cellState[30]; // cell current state
	float cellTarget[20]; // cell target
}cellPara;

// define pso parameter
struct psoParaStruct{
	int np; // swarm number
	float iner; // inertial value
	int maxIter; // max iteration number
	int stopIter; // iteration number that begin to check for stop
	float c; // correlation factor
	int dim; // input variables dimension
	int flagWarmStart; // if use warm start or not
}psoPara;

////////////////////// define functions
// generate random number
float GenerateRandomNum(float lowerBound, float upperBound);
MTRand drand;

// cost function
float CellFunction(float x[], int xDim, cellParaStruct cell);

// find local best coordinate and value
void UpdateLocalBest(float x[], float xlb[], float clb[], cellParaStruct cell, int xDim, int np);

// find global best
float UpdateGlobalBest(float xlb[], float clb[], float xgb[], cellParaStruct cell, int xDim, int np);




void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
	// define values that pass from Matlab
    mxArray *fun_in, *np_in, *lb_in, *ub_in, *inertia_in, *correction_factor_in, *iteration_in, *stopIter_in, *x0_in;
    double *fun_val = new double, *np_val = new double, *lb_val = new double, *ub_val= new double, *inertia_val= new double, *correction_factor_val= new double, *iteration_val= new double, *stopIter_val= new double, *x0_val= new double, *obs_val= new double;
    const int *dims = mxGetDimensions(prhs[2]);
    const int *dimsWarmStart = mxGetDimensions(prhs[8]);
    fun_in = mxDuplicateArray(prhs[0]);
    np_in = mxDuplicateArray(prhs[1]);
    lb_in = mxDuplicateArray(prhs[2]);
    ub_in = mxDuplicateArray(prhs[3]);
    inertia_in = mxDuplicateArray(prhs[4]);
    correction_factor_in = mxDuplicateArray(prhs[5]);
    iteration_in = mxDuplicateArray(prhs[6]);
    stopIter_in = mxDuplicateArray(prhs[7]);
    x0_in = mxDuplicateArray(prhs[8]);
    fun_val = mxGetPr(fun_in);
	np_val = mxGetPr(np_in);
	lb_val = mxGetPr(lb_in);
	ub_val = mxGetPr(ub_in);
	inertia_val = mxGetPr(inertia_in);
	correction_factor_val = mxGetPr(correction_factor_in);
	iteration_val = mxGetPr(iteration_in);
	stopIter_val = mxGetPr(stopIter_in);
	x0_val = mxGetPr(x0_in);
    
    // Define the values that pass out to the matlab
    mxArray *xMin_out, *yMin_out, *cgb_out;
    double *xMin_val = new double, *yMin_val = new double, *cgb_val = new double;
    xMin_out = plhs[0] = mxCreateDoubleMatrix((int)dims[0],1,mxREAL);
    yMin_out = plhs[1] = mxCreateDoubleMatrix(1,1,mxREAL);
    cgb_out = plhs[2] = mxCreateDoubleMatrix(iteration_val[0]+1,1,mxREAL);
    xMin_val = mxGetPr(xMin_out);
    yMin_val = mxGetPr(yMin_out);
    cgb_val = mxGetPr(cgb_out);

	// define cellPara, psoPara, particles
	cellPara.cellNo = fun_val[0];
	for (int i = 0; i < cellPara.cellNo; i++)
	{
		cellPara.cellSpeed[i] = fun_val[1+i];
		cellPara.cellA[i] = fun_val[1+cellPara.cellNo+i];
		cellPara.cellState[i*3+0] = fun_val[1+2*cellPara.cellNo+i*3+0];
		cellPara.cellState[i*3+1] = fun_val[1+2*cellPara.cellNo+i*3+1];
		cellPara.cellState[i*3+2] = fun_val[1+2*cellPara.cellNo+i*3+2];
		cellPara.cellTarget[i*2+0] = fun_val[1+2*cellPara.cellNo+3*cellPara.cellNo+i*2+0];
		cellPara.cellTarget[i*2+1] = fun_val[1+2*cellPara.cellNo+3*cellPara.cellNo+i*2+1];
	}
	psoPara.iner = inertia_val[0];
	psoPara.maxIter = iteration_val[0];
	psoPara.np = np_val[0];
	psoPara.stopIter = stopIter_val[0];
	psoPara.c = correction_factor_val[0];
	psoPara.dim = dims[0];
	if (dimsWarmStart[0] > 0)
		psoPara.flagWarmStart = 1;
	else
		psoPara.flagWarmStart = 0;
	float x[maxDim*maxNP]; // particle coordinate
	float xlb[maxDim*maxNP]; // local best
	float clb[maxNP]; // local best value
	float xgb[maxDim]; // global best
	float cgb = 0; // global best value
	float v[maxDim*maxNP]; // velocity
	float lb[maxDim]; // lower bound
	float ub[maxDim]; // upper bound
	float x0[maxDim]; // warm start value
	for (int i = 0; i < psoPara.dim; i++)
	{
		lb[i] = lb_val[i];
		ub[i] = ub_val[i];
	}
	if (psoPara.flagWarmStart == 1)
	{
		for (int i = 0; i < psoPara.dim; i++)
		{
			// if x0[i] is not defined, give a random number to it
			if (x0_val[i] != 100000)
				x0[i] = x0_val[i];
			else
				x0[i] = GenerateRandomNum(lb[i],ub[i]);
		}
	}

	// initialize the x, xlb, xgb and v value
	float *p = xlb;
	if (psoPara.flagWarmStart == 1)
	{
		for (int i = 0; i < psoPara.np; i++)
		{
			for (int j = 0; j < psoPara.dim; j++)
			{
				x[i*psoPara.dim+j] = GenerateRandomNum(lb[j],ub[j]);
				xlb[i*psoPara.dim+j] = x0[j];
				v[i*psoPara.dim+j] = GenerateRandomNum(-abs(ub[j]-lb[j]),abs(ub[j]-lb[j]));
			}
			clb[i] = CellFunction(p, psoPara.dim, cellPara);
			p += psoPara.dim;
		}
		for (int i = 0; i < psoPara.dim; i++)
			xgb[i] = x0[i];
		cgb = CellFunction(xgb, psoPara.dim, cellPara);
	}
	else
	{
		for (int i = 0; i < psoPara.np; i++)
		{
			for (int j = 0; j < psoPara.dim; j++)
			{
				x[i*psoPara.dim+j] = GenerateRandomNum(lb[j],ub[j]);
				xlb[i*psoPara.dim+j] = x[i*psoPara.dim+j];
				v[i*psoPara.dim+j] = GenerateRandomNum(-abs(ub[j]-lb[j]),abs(ub[j]-lb[j]));
			}
			clb[i] = CellFunction(p, psoPara.dim, cellPara);
			p += psoPara.dim;
		}
		cgb = UpdateGlobalBest(xlb, clb, xgb, cellPara, psoPara.dim, psoPara.np);
	}
    cgb_val[0] = cgb;
    
	// run pso algorithm to find the global minimum
	for (int i = 0; i < psoPara.maxIter; i++)
	{
		// update velocity
		for (int j = 0; j < psoPara.np; j++)
			for (int k = 0; k < psoPara.dim; k++)
				v[j*psoPara.dim+k]=psoPara.iner*v[j*psoPara.dim+k]+psoPara.c*GenerateRandomNum(0,1)*(xlb[j*psoPara.dim+k]-x[j*psoPara.dim+k])+psoPara.c*GenerateRandomNum(0,1)*(xgb[k]-x[j*psoPara.dim+k]);
    
		// update coordinate
		float tmpX = 0;
		for (int j = 0; j < psoPara.np*psoPara.dim; j++)
		{
			tmpX = x[j]+v[j];
			v[j] = min(max(tmpX,lb[j%psoPara.dim]),ub[j%psoPara.dim])-x[j];
			x[j] = x[j]+v[j];
		}

		// update local best
		UpdateLocalBest(x, xlb, clb, cellPara, psoPara.dim, psoPara.np);

		// update global best
		cgb = UpdateGlobalBest(xlb, clb, xgb, cellPara, psoPara.dim, psoPara.np);
        cgb_val[i+1] = cgb;
	}

    // pass the data out to matlab
    yMin_val[0] = cgb;
	for (int i = 0; i < psoPara.dim; i++)
		xMin_val[i] = xgb[i];
    
    

	// delete pointer
    mxFree(p);
    mxFree(fun_val);
    mxFree(np_val);
    mxFree(lb_val);
    mxFree(ub_val);
    mxFree(inertia_val);
    mxFree(correction_factor_val);
    mxFree(iteration_val);
    mxFree(stopIter_val);
    mxFree(x0_val);
}

// generate random number
float GenerateRandomNum(float lowerBound, float upperBound)
{
	float j = drand();
	float randNum = j * (upperBound - lowerBound) + lowerBound;
	return randNum;
}

// cost function
float CellFunction(float x[], int xDim, cellParaStruct cell)
{
    // ini para
    float minCostAllHorizon = 100000;
    float maxCostEachHorizon = 0;
    float cost = 0;
    
    // find the max cost in each horizon and min among all the horizon
    for (int i = 0; i < xDim; i++)
    {
        maxCostEachHorizon = 0;
        for (int j = 0; j < cell.cellNo; j++)
        {
            // update state
			cell.cellState[j*3+2] = cell.cellState[j*3+2] + cell.cellA[j]*sin(x[i]-cell.cellState[j*3+2]);
			cell.cellState[j*3+0] = cell.cellState[j*3+0] + cell.cellSpeed[j]*cos(cell.cellState[j*3+2]);
			cell.cellState[j*3+1] = cell.cellState[j*3+1] + cell.cellSpeed[j]*sin(cell.cellState[j*3+2]);
            
            // update cost and find max
            cost = sqrt(pow(cell.cellState[j*3+0]-cell.cellTarget[j*2+0],2)+pow(cell.cellState[j*3+1]-cell.cellTarget[j*2+1],2));
            if (cost > maxCostEachHorizon)
                maxCostEachHorizon = cost;
        }
        // find min cost for all horizon
        if (maxCostEachHorizon < minCostAllHorizon)
        {
            minCostAllHorizon = maxCostEachHorizon;
        }
    }
    
    // return
    return minCostAllHorizon;
}

// find global best
float UpdateGlobalBest(float xlb[], float clb[], float xgb[], cellParaStruct cell, int xDim, int np)
{
	// find min
	float minCost = 1000000;
	for (int i = 0; i < np; i++)
	{
		if (minCost>clb[i])
			minCost = clb[i];
	}

	// update xgb
	for (int i = 0; i < np; i++)
	{
		if (minCost == clb[i])
		{
			for (int j = 0; j < xDim; j++)
				xgb[j] = xlb[i*xDim+j];
			return CellFunction(xgb, xDim, cell);
		}
	}
}

// find local best coordinate and value
void UpdateLocalBest(float x[], float xlb[], float clb[], cellParaStruct cell, int xDim, int np)
{
	float *p = x;
	float cost = 0;

	// calculate cost and update xlb and clb
	for (int i = 0; i < np; i ++)
	{
		cost = CellFunction(p, xDim, cell);
		if (cost < clb[i])
		{
			clb[i] = cost;
			for (int j = 0; j < xDim; j++)
				xlb[i*xDim+j] = p[j];
		}
		p += xDim;
	}
}