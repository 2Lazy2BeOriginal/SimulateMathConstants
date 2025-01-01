# Setup

Suppose that you have a deck of cards labeled 1-52 on a desk. Then you randomly shuffle the cards and place them in a line again. The probability that **none** of the cards are in the same *relative order* on the desk is 1/e. 

Similarly, suppose that in a lecture hall and everyone hangs a jacket in the back of the room. The fire alarm comes off and in a rush, everyone grabs a jacket at random and leaves. The probability that **no one** picked the correct jacket is again 1/e. 
(Note this assumes that it is purely random and the students are not able to use any physical features to differentiate other jackets. A case analogous to this is assuming it is dark and no one can see the colour of their jacket).

Or how about this? A play players in a slot machine with a 1 in 10000 chances of winning. The probability that a player loses all 10000 times is 1/e
## Why does this work? 

Using the slot machine example. The player has a 1/10000 chance of winning which also means a 1 - 1/10000 chance of losing. And since each round is independent of previous slots, we can multiply each round together. When we combine this together, we get 

$$\left(1 - \frac{1}{10000}\right)^{10000}$$

Notice the parallel with the limit definition of $e$ 

$$ \lim_{n\to\infty}\left(1 + \frac{1}{n}\right)^n$$
It differs by a minus sign and so we take the reciprocal of e provided that the probabilities are sufficiently low.

## Some technicalities

You may have noticed that the deck of cards and jacket examples are not independent. However the chances of reselecting the same sample is essentially zero. (Think of picking a random person in a lecture hall blindfolded and doing it again. The chances they are same person is astronomically low that it basically doesn't change anything)

The *real* answer is to use derangements. Which is a way to count the ways to randomly permute a collection of objects such that **none** of the objects were in the original position. 

## Intuition behind it
For example, consider 4 people playing musical chairs (with chairs labelled 1-4) And after each round 4 people frantically find a seat again. Here is how we would count all the derangements. It is easier to consider how 1,2,3, or 4 people can be *out of place*

## Why it equals 1/e
A **Derangement** calculation formula is 
$$n!\sum_{k = 0}^n \frac{(-1)^k}{k!}$$
And if we want to find the probability that **none are in original position** is is simply
$$\frac{none \ in \ original \ position}{all \ possible \ arrangements} = \frac{D(n)}{n!} = \sum_{k = 0}^n \frac{(-1)^k}{k!}$$
Recall the Taylor series approximation for $e^x$ is 
$$e ^x = \sum_{k = 0}^\infty \frac{x^k}{k!}$$
This is a special case where x = -1. And as we let x gets sufficiently large, it approaches 1/e

Credit to **Zach Star** on his video of e. Link is [here](https://www.youtube.com/watch?v=AAir4vcxRPU&t=854s)
