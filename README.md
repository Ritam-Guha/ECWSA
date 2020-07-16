# MATLAB code for ECWSA: Embedded Chaotic Whale Survival Algorithm

Code to perform feature selection.

### Paper Reference - Guha, R., Ghosh, M., Mutsuddi, S. et al. Embedded chaotic whale survival algorithm for filter–wrapper feature selection. Soft Comput (2020). https://doi.org/10.1007/s00500-020-05183-1.

## Parameters

To Run the code, set the values of the following properties in main_ECWSA file:
* datasets = names of the input datasets (divided into train and test samples)
* populationSize = initial count of search agents (later adjusted due to death of unfit whales)
* iteration = maximum number of iterations allowed
* fold = The value k in k-fold crossValidation
* k = Value of k in K-nearest neighbors classifier

***Note: We have used only KNN classifier to obtain accuracy, you can use other classifiers as well. But, you need to change the _crossValidation.m_ file to use the other classifier and change the knnClassifier function call to the new classifier wherever it appears in the code***


## Running the code
* Set all the required parameters
* run file _main_ECWSA.m_

Link for algorithm details: [Paper](https://link.springer.com/article/10.1007/s00500-020-05183-1?wt_mc=Internal.Event.1.SEM.ArticleAuthorOnlineFirst&utm_source=ArticleAuthorOnlineFirst&utm_medium=email&utm_content=AA_en_06082018&ArticleAuthorOnlineFirst_20200716)

## Abstract:

Classification accuracy provided by a machine learning model depends a lot on the feature set used in the learning process. Feature selection (FS) is an important and challenging preprocessing technique which helps to identify only the relevant features from a dataset, thereby reducing the feature dimension as well as improving the classification accuracy at the same time. The binary version of whale optimization algorithm (WOA) is a popular FS technique which is inspired from the foraging behavior of humpback whales. In this paper, an embedded version of WOA called embedded chaotic whale survival algorithm (ECWSA) has been proposed which uses its wrapper process to achieve high classification accuracy and a filter approach to further refine the selected subset with low computation cost. Chaos has been introduced in the ECWSA to guide selection of the type of movement followed by the whales while searching for prey. A fitness-dependent death mechanism has also been introduced in the system of whales which is inspired from the real-life scenario in which whales die if they are unable to catch their prey. The proposed method has been evaluated on 18 well-known UCI datasets and compared with its predecessors as well as some other popular FS methods. 
