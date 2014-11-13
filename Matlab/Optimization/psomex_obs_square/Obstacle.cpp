#include <vector>
#include <array>
#include "Obstacle.h"

using namespace std;

Obstacle::Obstacle(void)
{
        // obstacle type
        obsType = 0;
        // obstacle potential type
        potentialType = 0;
        // potential weighting facotr
        potentialWeightingFactor = 0;
        // obstacle center
        obsCenter = new vector<vector<double>*>;
        // obstacle radius
        obsRadius = new vector<double>;
        // obstacle exponential tolerance
        obsExpTol = new vector<double>;
        // obstacle exponential weight factor
        obsExpWeight = new vector<double>;
        // obstacle impulse potential value
        obsImpulsePotential = new vector<double>;
        // obstacle impulse tolerance value
        obsImpulseTol = new vector<double>;
}
Obstacle::~Obstacle(void)
{
    /*
        // obstacle center
        delete obsCenter;
        // obstacle radius
        delete obsRadius;
        // obstacle exponential tolerance
        delete obsExpTol;
        // obstacle exponential weight factor
        delete obsExpWeight;
        // obstacle impulse potential value
        delete obsImpulsePotential;
        // obstacle impulse tolerance value
        delete obsImpulseTol;
     */
}