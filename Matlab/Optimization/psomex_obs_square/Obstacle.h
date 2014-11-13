#ifndef OBSTACLE_H
#define OBSTACLE_H

#include <vector>
#include <array>

using namespace std;

class Obstacle
{
	public:
        // obstacle type (1: circle; 2: square)
        int obsType;
        // obstacle potential type (1: exp; 2: impulse)
        int potentialType;
        // potential weighting facotr
        int potentialWeightingFactor;
        // obstacle center
        vector<vector<double>*>* obsCenter;
        // obstacle radius
        vector<double>* obsRadius;
        // obstacle exponential tolerance
        vector<double>* obsExpTol;
        // obstacle exponential weight factor
        vector<double>* obsExpWeight;
        // obstacle impulse potential value
        vector<double>* obsImpulsePotential;
        // obstacle impulse tolerance value
        vector<double>* obsImpulseTol;

	public:
		// constructor
		Obstacle(void);
        // destructor
        ~Obstacle(void);
};

#endif