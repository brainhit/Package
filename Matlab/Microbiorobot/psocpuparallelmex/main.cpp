#include <stdio.h>
#include <array>
#include <iostream>
#include <vector>
#include <algorithm>
#include <time.h>
#include "CostFuncTarget.h"
#include "pso.h"
#include "TetrahymenaSwarm.h"
#include "Particles.h"

#define PI 3.14159265358

using namespace std;

int main(void)
{
	//// test
	// robot info
	int cellNum = 2;
	//double cellInfo[6] = {30,50,60,0.7,0.4,0.6};
	//double states[15] = {0,20,0,0,0,0,0,0,0,50,120,200,-160,100,100};
	//double x0[15] = {-3.1108,0.5,3.1315,-3.1416,-0.4347,-0.9854,-1.3518,-1.7880,3.1416,3.1416,3.1416,2.7991,2.1496,1.9199,1.6218};
	//double x0[15] = {-3.1108,100000,3.1315,-3.1416,-0.4347,-0.9854,-1.3518,-1.7880,3.1416,3.1416,3.1416,2.7991,2.1496,1.9199,1.6218};
	//int cellNum = 2;
	double cellInfo[4] = {30,50,0.7,0.4};
	double states[10] = {0,20,0,0,0,0,50,120,200,-160};
	//double x0[15] = {-3.1108,0.5,3.1315,-3.1416,-0.4347,-0.9854,-1.3518,-1.7880,3.1416,3.1416,3.1416,2.7991,2.1496,1.9199,1.6218};
	double x0[15] = {-3.1108,1.6097,3.1315,-3.1416,-0.4347,-0.9854,-1.3518,-1.7880,3.1416,3.1416,3.1416,2.7991,2.1496,1.9199,1.6218};
	//double x0[15] = {100000,100000,100000,100000,100000,100000,100000,100000,100000,100000,100000,100000,100000,100000,100000};

	double iner = 0.1;
	double c = 2;
	int iter = 40;
	int stopIter =10;
	int stepToTarget = 15;
	int np = 200;
	vector<double>* lb = new vector<double>;
	vector<double>* ub = new vector<double>;
	for (int i = 0; i < stepToTarget; i++)
	{
		lb->push_back(-PI);
		ub->push_back(PI);
	}
	vector<double>* warmStartPosition = new vector<double>;
	for (int i = 0; i < 15; i++)
		warmStartPosition->push_back(x0[i]);
	TetrahymenaSwarm swarm;
	swarm.cellNo = cellNum;
	for (int i = 0; i<swarm.cellNo; i++)
	{
		swarm.cellSpeed->push_back(cellInfo[i]);
		swarm.angularChangingRate->push_back(cellInfo[swarm.cellNo+i]);
		array<double,3>* cell = new array<double,3>;
		for (int j = 0; j < 3; j++)
			cell->at(j) = states[i*3+j];
		swarm.curState->push_back(cell);
		array<double,2>* target = new array<double,2>;
		for (int j = 0; j < 2; j++)
			target->at(j) = states[i*2+j+swarm.cellNo*3];
		swarm.targetPoints->push_back(target);
	}
	swarm.stepToTarget = stepToTarget;


	//TetrahymenaSwarm swarm;
	//swarm.cellNo = 3;
	//swarm.cellSpeed->push_back(30);
	//swarm.cellSpeed->push_back(50);
	//swarm.cellSpeed->push_back(60);
	//swarm.angularChangingRate->push_back(0.7);
	//swarm.angularChangingRate->push_back(0.4);
	//swarm.angularChangingRate->push_back(0.6);
	//array<double,3>* cell1 = new array<double,3>;
	//cell1->at(0) = 0;
	//cell1->at(1) = 20;
	//cell1->at(2) = 0;
	//array<double,3>* cell2 = new array<double,3>;
	//cell2->at(0) = 0;
	//cell2->at(1) = 0;
	//cell2->at(2) = 0;
	//array<double,3>* cell3 = new array<double,3>;
	//cell3->at(0) = 0;
	//cell3->at(1) = 0;
	//cell3->at(2) = 0;
	//swarm.curState->push_back(cell1);
	//swarm.curState->push_back(cell2);
	//swarm.curState->push_back(cell3);
	//array<double,2>* target1 = new array<double,2>;
	//array<double,2>* target2 = new array<double,2>;
	//array<double,2>* target3 = new array<double,2>;
	//target1->at(0) = 50;
	//target1->at(1) = 120;
	//target2->at(0) = 200;
	//target2->at(1) = -160;
	//target3->at(0) = 100;
	//target3->at(1) = 100;
	//swarm.targetPoints->push_back(target1);
	//swarm.targetPoints->push_back(target2);
	//swarm.targetPoints->push_back(target3);
	//swarm.stepToTarget = 15;

	// define pso obj
	pso psoObj;

	//// run the pso function
	srand(time(NULL));
	const clock_t begin_time = clock();
	psoObj.PSOAlgorithm(CostFuncTarget::CellFunction, swarm, np, lb, ub, iner, c, iter, stopIter, warmStartPosition);
	std::cout << "time cost is "<<double( clock () - begin_time ) /  CLOCKS_PER_SEC<<endl;
	// get the best cost and best solution
	double cost = psoObj.GetCostValue();
	// get the best solution to the cost function
	vector<double>* bestSolution = new vector<double>;
	bestSolution = psoObj.GetBestFuncSolution();
	cout<<"cost function value is "<<cost<<endl;
	for (int i = 0; i < (int)bestSolution->size(); i++)
		cout<<bestSolution->at(i)<<endl;
	cin>>c;

	// delete pointer
	delete bestSolution;
	delete lb;
	delete ub;
	delete warmStartPosition;
  
	return 0;
}
