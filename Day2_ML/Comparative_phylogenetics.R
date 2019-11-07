#This script was written for a comparative phylogenetics lab on November 15th, 2018
#using trees built from the Ruhfel et al. 2014 paper we go through ancestral state reconstructions of simulated continuous traits,
# SIMMAP of discrete traits, and MuSSE diversification analyses

#set your working directory of all your files that you will be using
setwd("/Users/jacoblandis/Desktop/Comprative")

######################################################################################################
#### Compare presence/absence of clades between Parsimony and likelihood trees ###########################
#####################################################################################################
#launch ape, if phytools is not installed it will do so
if (!require(ape)) install.packages('ape')
library(ape)

#read in your different trees by calling them different variable names
Parsimony <- read.tree("ruhf_32_parsimony.tre")
ML <- read.tree("RAxML_bestTree.32_outgroup.tre")
Bayesian <- read.tree("MrBayes_MCC.tre")

#we will compare two trees at a time and created a PDF of each comparison
pdf("Parsiomony_vs_ML.pdf",20,20)
comparePhylo(Parsimony,ML, plot=TRUE)
dev.off()

#we will compare two trees at a time and created a PDF of each comparison
pdf("ML_vs_Bayesian.pdf",20,20)
comparePhylo(ML,Bayesian, plot=TRUE)
dev.off()

###########################################################################
#### Continuous ancestral state reconstruction ###########################
##########################################################################

#launch phytools, if phytools is not installed it will do so
if (!require(phytools)) install.packages('phytools')
library(phytools)

#read in tree as a nexus file
mytree <- read.nexus("RAxML_32.nex")

#plot tree to see what it looks like
plot(mytree)

#we are going to simulate a continuous character across the tree using BM
x <-fastBM(mytree,10,sig2=100,bounds=c(0,20))
x

#now that we have a tree and characters, we can look at ancestral states
fit <- fastAnc(mytree, x)
fit

#see how the ancestral state reconstructions at nodes compare
plot(fit)

#projection of the reconstruction onto the edges of hte tree
obj <- contMap(mytree,x, plot=FALSE)
obj

#plot the tree
plot(obj,legend=0.7*max(nodeHeights(mytree)),sig=2,fsize=c(0.7,0.9))

#another way to look at character change
phenogram(mytree,x, fsize=0.5, spread.costs=c(1,0))

#plot the 95% confidence interval of the traits
fancyTree(mytree, type="phenogram95", x=x, fsize=0.5)

#create a data matrix from our BM simulated data and our OU simulated data
XY <- cbind(x,y)
## project into morphospace
phylomorphospace(mytree, XY, label = "horizontal")


#now lets try simulating data under the OU model
y <- fastBM(mytree, model="OU",sig2=1000, bounds=c(0,20))
y

#now that we have a tree and characters, we can look at ancestral states
fit <- fastAnc(mytree, y)
fit

#see how the ancestral state reconstructions at nodes compare
plot(fit)

obj <- contMap(mytree,y, plot=FALSE)
obj

#plot the tree
plot(obj,legend=0.7*max(nodeHeights(mytree)),sig=2,fsize=c(0.7,0.9))

#plot the 95% confidence interval of the traits from OU
fancyTree(mytree, type="phenogram95", x=y, fsize=0.5)

#create a data matrix from our BM simulated data and our OU simulated data
XY <- cbind(x,y)
## project into morphospace
phylomorphospace(mytree, XY, label = "horizontal")

#now plot your own gene tree and simulate data across it using the guidelines above
geneTree <- read.nexus("MCC_atpB.nex")

#plot the gene tree as a fan
plot(geneTree,type="fan",cex=0.4)

#when plotting ancestral state reconstructions on a large tree use type="fan" to plot circular tree

#######################################################################################
### Discrete character evolution with SIMMAP   #######################################
######################################################################################

if (!require(phytools)) install.packages('phytools')
library(phytools)

#read in tree as a nexus file
mytree <- read.nexus("RAxML_32.nex")

#make sure our tree is correct
plot(mytree)

#three states with the possible transition matrix
Q<-matrix(c(-4,2,2,2,-4,2,2,2,-4),3,3)
Q
rownames(Q)<-colnames(Q)<-letters[1:3]
simData<-sim.history(mytree,Q)$states
simData

#pick the colors for plotting for each of the three characters
cols <- setNames(c("blue","red","black"), sort(unique(simData)))

#perform stochastic mapping
onetree <- make.simmap(mytree, simData, nsim=1, model="ARD")
plotSimmap(onetree,colors=cols, fsize=0.5)

#run the simulation 100 times over the tree
mtrees <- make.simmap(mytree, simData, nsim=100, model="ARD")
mtrees

#summarize the simulations. How often was each state found on the tree?
pd <- summary(mtrees, plot=FALSE)
pd

#plot the summary
plot(pd, fsize=0.6, ftype="i", colors=cols)

#plot a random map with an overlay of the posterior probabilties
plot(mtrees[[1]], cols,fsize=0.8)
nodelabels(pie=pd$ace,piecol=cols,cex=0.5)

#simulate characters on your large tree and perform stochastic mapping
#try comparing two different models of trait evolution All Rates Different "ARD", Equal Rates "ER", or symmetrical rates "SYM"

##########################################################################################
############ State dependent diversification #############################################
#########################################################################################

if (!require(diversitree)) install.packages('diversitree')
library(diversitree)
library(phytools)

#read in tree as a nexus file
mytree <- read.nexus("RAxML_32.nex")

#even though we made an ultrametric tree in BEAST, we want to make sure it actually is
is.ultrametric(mytree)

#we can force it to be ultrametric since it should be
mytree <- force.ultrametric(mytree)

#test on more time
is.ultrametric(mytree)


#three states with the possible transition matrix
Q<-matrix(c(-8,4,4,4,-8,4,4,4,-8),3,3)
Q
rownames(Q)<-colnames(Q)<-1:3
simData<-sim.history(mytree,Q)$states
simData
#look at the number of species in each state
table(simData)

#go ahead and write this to a CSV file so we can know what the states were for later
write.csv(simData, file="trait_data.csv", quote=FALSE)

#read in the same csv, telling the program species names are in the first column
mydata <- read.csv("trait_data.csv",row.names=1)
states <- mydata[,1]
names(states) <- row.names(mydata)

#create the basic MuSSE function with 3 states
lik <- make.musse(mytree, states, 3)
lik

#names of the arguments we are dealing with
argnames(lik)

#heuristic guess as to sensible starting point in the search
p <- starting.point.musse(mytree,3)
p

#fit the base model with a likelihood equation with all paramters
fit.base <- find.mle(lik, p[argnames(lik)])

#round to three decimal places
round(coef(fit.base),3)

#test hypothesis of whether the model is better with different speciation rates or when they are constrained
lik.lambda <- constrain(lik, lambda2 ~ lambda1, lambda3 ~ lambda1)

#perform ML search again but this time with the constrained model
fit.lambda <- find.mle(lik.lambda, p[argnames(lik.lambda)])

#round to three decimal places
round(coef(fit.lambda),3)

#perform statistical to determine which model (full or speciation constrained) is better
anova(fit.base, free.lambda=fit.lambda)

#do a similar search but this time with extinction rates constrained
lik.mu <- constrain(lik, mu2 ~ mu1, mu3 ~ mu1)

#fit this new model with a ML equation
fit.mu <- find.mle(lik.mu, p[argnames(lik.mu)])

round(coef(fit.mu),3)

#perform a second statistical test to see if the full model or constrained extinction is better
anova(fit.base, free.lambda=fit.mu)

#we will perform a MCMC analysis to explore parameter space
prior.exp <- make.prior.exponential(2)
set.seed(1)
#we aren't going to run the analyses for many steps, but usually I like to do at least 10,000 to get smoother parameter distributions
samples <- mcmc(lik, coef(fit.base), fail.value=NULL, nsteps=500, prior=prior.exp, w=1, print.every=50)

#plot a graph showing the speciation rates for the three character states
col <- c("blue", "red", "purple")
profiles.plot(samples[c("lambda1", "lambda2", "lambda3")], col.line=col, las=1, xlab="Speciation rate", legend="topright", font=2, cex.lab=1, font.lab=1, cex.legend=0.5, margin=1/2)

#plot a similar graph to show extinction rates between the three character states
col <- c("blue", "red", "purple")
profiles.plot(samples[c("mu1", "mu2", "mu3")], col.line=col, las=1, xlab="Extinction rate", legend="topright",font=2, cex.lab=1, font.lab=1, cex.legend=1, margin=1/2)

#plot a third graph showing net diversification rates between the three characters
samples$net1 <- samples$lambda1 - samples$mu1
samples$net2 <- samples$lambda2 - samples$mu2
samples$net3 <- samples$lambda3 - samples$mu3
col <- c("blue", "red", "purple")
profiles.plot(samples[c("net1", "net2", "net3")], col.line=col, las=1,	xlab="Net diversification rate", legend="topright", font=2, cex.lab=1, font.lab=1, cex.legend=1, margin=1/2)

#perfor an ancestral state reconstruction using the same data to see how the traits are dispersed along the tree
fit <- find.mle(lik, p[argnames(lik)])
st <- asr.marginal(lik, coef(fit))
#this method produces a circle tree, easy to read
state.colors <- c("blue", "red", "purple")
plot(mytree, type = "fan", label.offset=1.5, cex = 0.25, no.margin=TRUE)
nodelabels(pie = t(st), piecol = state.colors, cex = 0.35)

