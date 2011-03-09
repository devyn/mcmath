/*
 *  BBContactListener.h
 *  BrickBreaker
 *
 *  Created by Devyn Cairns on 11-03-07.
 *  Copyright 2011 __MyCompanyName__. All rights reserved.
 *
 *  Some source taken from <http://www.raywenderlich.com/505/how-to-create-a-simple-breakout-game-with-box2d-and-cocos2d-tutorial-part-22>
 *  I decided to use that implementation because it seemed to be what I was looking for.
 *
 */

#include "Box2D/Box2D.h"
#include <vector>
#include <algorithm>

struct BBContact {
	b2Fixture *fixtureA;
	b2Fixture *fixtureB;

	bool operator==(const BBContact &other) const
	{
		return (fixtureA == other.fixtureA) && (fixtureB == other.fixtureB);
	}
};

class BBContactListener : public b2ContactListener {

public:
	std::vector<BBContact>contacts;

	BBContactListener();
	~BBContactListener();

	virtual void BeginContact(b2Contact *contact);
	virtual void EndContact(b2Contact *contact);
    virtual void PreSolve(b2Contact *contact, const b2Manifold *oldManifold);
	virtual void PostSolve(b2Contact *contact, const b2ContactImpulse *impulse);

};
