#include "Particles.h"
#include <vector>

using namespace std;

Particles::Particles()
{
	curPosition = new vector<vector<double>*>;
	velocity = new vector<vector<double>*>;
	localBestPosition = new vector<vector<double>*>;
	localBestValue = new vector<double>;
	globalBestPosition = new vector<double>;
	globalBestValue = 0;
}
Particles::~Particles()
{
    /*
	delete curPosition;
	delete velocity;
	delete localBestPosition;
	delete localBestValue;
	delete globalBestPosition;
     */
}