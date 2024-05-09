# Data-Mining-PER
Data mining textual and codified student information taken from three semesters of introductory physics course utilizing CourseNetworking (CN), a course-designed social media platform. The study was part of physics education research (PER). 

# Course Networking
CourseNetworking (CN) is a global academic networking site. The founder of CN is Dr Ali Jafari, professor of Computer and Information Technology at IUPUI as well as the director of Cyberlabs located at IUPUI, a research and development site for CN which also holds offices in Kuala Lumpur, Malaysia and Guangzhou, China. The function of CN is to provide a course “networking” platform rather than course “management” system. CN enables students to communicate more efficaciously than traditional learning management systems (LMS). The LMS at IUPUI is Canvas, which has the advantage of having a central hub where course material is retrievable and administered. The only means of communication typically on the LMS is an online discussion or announcement board. CN provides a more natural environment for networking and communication, with many similarities to features implemented by Facebook. An interesting feature of CN is anar seeds which are a form of “micro-rewards”. These are gained through use of CN via logging in, posting, reflecting and even polling in addition to clicking a “like” button for each post or reflection similar to Facebook. Another similarity with Facebook is a “wall” format with postings by all the members made visible at the home page of the class or group. The control of the instructor is in the setting up of the class or group page with the point weight decided in advance for each action (login, posting, reflecting, polling and liking). A limit can also be imposed on the number of anar seeds students can gain each day. This hinders students from accumulating all required points for extra credit at the end of the semester. The introductory physics courses awarded 5% extra credit if more than 350 anar seeds were earned.
## Data
Around 3000 posts and reflections were recorded in a semester in the 19 weeks of each course.
![image](https://github.com/kelleypa/Data-Mining-PER/assets/107891103/175150e5-59c0-48bc-b2f2-be4cfc1ad79a)

# Research Questions
1) **Gender Study:** Are there gender differences in the observed sentiment?
2) **Activity Study:** Are there differences in sentiment or performance between students who participate heavily on CN and those who do not? In other words, is there any sentiment overshadowing?
3) **Time of Day Study** Do students that post more at night express different sentiment or perform differently academically than students that post only during the day?



# Network Analysis

We made use of some fundamental network visualization tools in R when first experimenting on our data, before heading in the direction of sentiment analysis. We prepared the data by interpreting reflections as connections to the original poster, or user that created the post thread. We arranged the data in a spreadsheet by creating a column of users, labeled by their unique identification numbers, separated by the student (in the From column) in communication to another student (in the To column).
![image](https://github.com/kelleypa/Data-Mining-PER/assets/107891103/13e665ee-e1af-4e39-8843-0cc58f80f7c5)

The igraph() function in R, we were able to produce a network plot of the fall 2014 semester, as an example. The initial plot was extremely tangled with their id number as individual nodes. Several functions exist to condense the jumbled mess into something more coherent. The function walktrap.community() does simulated short random walks to find packed regions of network that form ‘communities’. The following below graph illustrates the coagulation of the scattered network from five steps defining a community. The user id with the highest degree, or largest number of edges, became the name of the community node. The function contract.vertices then graphically merges the nodes into one and with some tweaking of the graph settings, yields the following igraph plot.

![image](https://github.com/kelleypa/Data-Mining-PER/assets/107891103/35ddd3cd-1a64-49de-a091-fc9fb20d1c84)

### Topic Modelling:
Topic modelling (TM) is a statistical means to extract the “topic” or theme of the textual data. The primary method for TM counts frequency of the words and determines the probability of finding words as well as probabilistic relations with other words. TM can find semantics through wordnets. Wordnets are large lexicons that group sets of nouns, adjectives, verbs and adverbs together by synonyms and basic concepts. These word sets are called synsets. R can perform this with the package ‘wordnet’.
![image](https://github.com/kelleypa/Data-Mining-PER/assets/107891103/b655596c-e5aa-41e5-b4ce-127408a8f395)
Another form of TM is LDA. LDA is one of the most popular tracks for generative statistical models. Fundamentally this model uses Bayesian inference, often applying the technique of Gibbs sampling. A common variation of Gibbs sampling, used by the R package ‘lda’, is collapsed Gibbs sampling. From this, R has the capability to feature the results by creating an interacting display by generating a JavaScript Object Notation (JSON) with changeable parameters, the number of topics and the weight of relevance for the topics denoted by λ that better controls the ranking of the topic relevance. The above figure illustrates the preliminary work using the package ’LDAvis’ done on the word corpus from Fall 2015. With this we can numerically find out which words are used, extract meaning from these combination of words and quantitatively find out how often students use these words and in effect, how often certain topics of discussion appear in the semester. Examples of these topics could be group meetings to do homework or review for exams, give reassurances to peers before and after exams, provide interesting materials relevant to the course or simple dialogues about miscellaneous topics. We can view these topics as classifications and consider them from the perspective of gender, activity or time of day.

# Syuzhet Package and NRC Lexicon: Eight Emotions & Two Sentiments


“Syuzhet" comes from the Russian Formalists Victor Shklovsky and Vladimir Propp 
* 2 components of narrative, the "fabula" and the "syuzhet" 
* syuzhet refers to the "device" or technique of a narrative
* fabula is the chronological order of events
* Syuzhet is concerned with the manner in which the elements of the story (fabula) are organized (syuzhet) 

Mathew Jockers, Nebraska Literary Lab
4 Word- Emotion Lexicons:
* "afinn" developed by Finn Årup Nielsen
* "bing" developed by Minqing Hu and Bing Liu
* "nrc" developed by Mohammad, Saif M. and Turney, Peter D
* “stanford” developed by The Stanford CoreNLP

Word- Emotion Lexicon Structure:
* Sentiment: positive, negative
* Eight Emotions: joy, trust, anticipation, surprise, sadness, fear, anger, digust

![image](https://github.com/kelleypa/Data-Mining-PER/assets/107891103/f14d0cce-4203-4575-ac97-63c0fb47a05e)

# Results
1) **Gender Study**
* CN can be a gender independent platform
2) **Activity Study**
* CN not dominated by most active users
3) **Time of Day Study**
* No link found between time of CN usage and student sentiment/performance
* CN can be used night or day

# For more details, check out my Master's Report (IUPUI_Master_Report.pdf).
