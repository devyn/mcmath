# BrickBreaker

This is a simple game inspired by BreakOut! and Arkanoid.

Box2D  is  included   in  `Box2D/`.  The  license  for   Box2D  is  in
`Box2D/License.txt`.

You may  need to set the  Base SDK; on  my laptop I've got  4.2.1, but
3.1.2 should be fine too.

## Rationale and Plan

The original BrickBreaker code is glitchy. Most of this could be fixed
with the  addition of a physics  engine, like Box2D. So  that's what I
plan to do.

The score  system is  quite broken  &mdash; if you  win, the  score is
always 200.  Making the scoring  more interesting and competitive is a
goal.  You shouldn't  really be  able to  play the  game the  same way
twice.

Humor keeps people interested. So there will be some of that. ;)

The original graphics are way  too simple. I think nice graphics would
help. Drawn by myself, of course.

And it's way  too easy! The original has only 20  bricks! I won't have
any of  that. There won't be  any difficulty setting,  either. Back in
the  days of  what is  now retro  gaming, people  were  entertained by
incredibly basic games. They were, however, incredibly competitive and
*difficult*. They seldom had much  of a story &mdash; they didn't need
one. They were just fun. And that is all BrickBreaker aspires to be.

## Rules

There's a paddle, a ball, and bricks. What more to say?

Well, actually,  there is  more to say.  It's what  makes BrickBreaker
unique.

- You have to hit the ball with some force; it doesn't just bounce off.
- The more  bricks you hit in a  row, the more score  per brick you'll
  get. If you hit multiple bricks without the ball touching the paddle
  again, you get extra points that keep adding on until you die.
- The paddle is tiny!
- The more  bricks you  hit in a  row, the  more the ball  will bounce
  around, too, up to a certain point. This should be a challenge! :)
- Your 'brick  value' will get  reset to 10  if you lose a  life. That
  happens  when  you  let  the   ball  through.  Don't  let  the  ball
  through. Got it?
- Score decays over time, albeit not by very much. Do it fast!

And really, I think that's about it.
