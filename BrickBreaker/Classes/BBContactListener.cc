/*
 *  BBContactListener.cc
 *  BrickBreaker
 *
 *  Created by Devyn Cairns on 11-03-07.
 *  Copyright 2011 __MyCompanyName__. All rights reserved.
 *
 */

#include "BBContactListener.h"

BBContactListener::BBContactListener() : contacts() {
}

BBContactListener::~BBContactListener() {
}

void BBContactListener::BeginContact(b2Contact* contact) {
    // We need to copy out the data because the b2Contact passed in
    // is reused.
    BBContact bbContact = { contact->GetFixtureA(), contact->GetFixtureB() };
    contacts.push_back(bbContact);
}

void BBContactListener::EndContact(b2Contact* contact) {
    BBContact bbContact = { contact->GetFixtureA(), contact->GetFixtureB() };
    std::vector<BBContact>::iterator pos;
    pos = std::find(contacts.begin(), contacts.end(), bbContact);
    if (pos != contacts.end()) {
        contacts.erase(pos);
    }
}

void BBContactListener::PreSolve(b2Contact* contact, 
								 const b2Manifold* oldManifold) {
}

void BBContactListener::PostSolve(b2Contact* contact, 
								  const b2ContactImpulse* impulse) {
}