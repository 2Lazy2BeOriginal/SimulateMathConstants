# Setup

Suppose we have two blocks A and B. Block B has a mass that is 100 to some power times larger than A. And also the blocks experiences zero friction and all collisions are perfectly elastic—no energy is lost. If Block A lies between a wall and Block B and we have block B start with *any* arbitrary speed towards Block A. The number of collisions has the same digits of $\pi$. 

Note that the initial speed of Block B **does not matter**. This is because since the collisions are completely elastic. The energies of the two Blocks add up to a constant. Put in another way

$$\frac{1}2m_1v_1^2 + \frac{1}2m_2v_2^2 = const$$
Since the mass are consistent throughout the simulation, the only thing that changes is the velocities. The explanation why it is connected with $\pi$ is quite theoretical and difficult to explain—but very interesting. So if you are interested, watch [3blue1brown](https://www.youtube.com/@3blue1brown) video on the topic [here](https://www.youtube.com/watch?v=HEfHFsfGXjs)
# Limitations 

Although the algorithm works for **all** digits of pi. Computers will start to lose some accuracy as we introduce more digits of $\pi$. Computers store decimal point numbers with a fixed number of digits. In our example, we are using a **double** which can store 16 digits of precision. This poses an issue once we reach 9 digits of pi as we are not able to store the velocities of the two blocks accurately anymore. And since we count the number of collisions millions of times, small inaccuracies become very noticeable. 

In addition, since the mass of Block B grows exponentially, the runtimes grows just as quickly so stuttering may occur at higher digits. This simulation was implemented in Java which is considered medium speed. Implementing in *C* or *C++* will make it run faster however the time savings are not enough to mitigate the exponential growth of the number of collisions. 

