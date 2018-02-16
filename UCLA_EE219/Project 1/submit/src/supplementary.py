import numpy as np
import matplotlib.pyplot as plt
import scipy

# used for data tokenlization
from sklearn.datasets import fetch_20newsgroups
import string
import re
import nltk
import nltk.stem
from nltk import word_tokenize
from nltk.stem import WordNetLemmatizer
# nltk.download('punkt')
# nltk.download('wordnet')

# used for modeling
from sklearn.feature_extraction import text
from sklearn import preprocessing
from sklearn import metrics
from sklearn.decomposition import NMF
from sklearn.svm import SVC
from sklearn.svm import LinearSVC
from sklearn.naive_bayes import GaussianNB
from sklearn.linear_model import LogisticRegression
from sklearn.multiclass import OneVsOneClassifier
from sklearn.multiclass import OneVsRestClassifier

def load_data():
    """
    Load in train and test datasets as well as the true labels.

    """

    cat_comp = ['comp.graphics', 'comp.os.ms-windows.misc', 'comp.sys.ibm.pc.hardware', 'comp.sys.mac.hardware']
    cat_rec = ['rec.autos', 'rec.motorcycles', 'rec.sport.baseball', 'rec.sport.hockey']
    categories = ['comp.graphics', 'comp.os.ms-windows.misc', 'comp.sys.ibm.pc.hardware', 'comp.sys.mac.hardware', 'rec.autos', 'rec.motorcycles', 'rec.sport.baseball', 'rec.sport.hockey']
    data_train = fetch_20newsgroups(subset = 'train', categories = categories, shuffle = True, random_state = 42)
    data_test = fetch_20newsgroups(subset = 'test', categories = categories, shuffle = True, random_state = 42)

    label_train = []
    for doc in data_train.target:
        if data_train.target_names[doc] in cat_comp:
            label_train.append(0)
        else:
            label_train.append(1)

    label_test = []
    for doc in data_test.target:
        if data_test.target_names[doc] in cat_comp:
            label_test.append(0)
        else:
            label_test.append(1)

    return data_train, data_test, label_train, label_test


def load_data_multi(categories):
    """
    Load in train and test datasets as well as the true labels.

    """

    data_train= fetch_20newsgroups(subset='train', categories=categories, shuffle=True, random_state= 42)
    data_test= fetch_20newsgroups(subset='test', categories=categories, shuffle=True, random_state= 42)
    label_train = data_train.target
    label_test = data_test.target

    return data_train, data_test, label_train, label_test


def pre_balance(train_data, test_data):
    """
    Fit the data into the same length.

    Input: training and test data.
    Output: Balanced training and test data.

    """

    min_max_scaler = preprocessing.MinMaxScaler()
    X_train = min_max_scaler.fit_transform(train_data.T)
    X_test = min_max_scaler.transform(test_data.T)

    return X_train.T, X_test.T


def plot_hist(categories, dataset):
    """
    Plot the histogram of the number of documents in the chosen 8 classess.
    Show that the number of docs are balanced.
    """

    len_data = []
    for i in np.arange(0,8):
        len_data.append(np.sum(dataset.target == i))
    bars = plt.barh(np.arange(8), len_data, 0.7, alpha = 0.8, color='bgrcmyk')
    plt.xlabel("num. of documents")
    plt.ylabel("subclasses")
    plt.title("number of documents in each subclass")
    plt.yticks(np.arange(8)+0.35, categories)
    plt.legend()
    plt.show()

    return

def TFxIDF(data_train, data_test):
    """
    Convert the training set and the test set into a TFxIDF matrix.

    Input: training and test data read from sklearn package.
    Output: two TFxIDF matrices with rows indicating num of documents,
    while cols indicating num of terms.

    """

    english_stemmer = nltk.stem.SnowballStemmer('english')

    regex = re.compile('[{:s}]'.format(string.punctuation))

    class LemmaTokenizer(object):
        def __init__(self):
            self.english_stemmer = nltk.stem.SnowballStemmer('english')
        def __call__(self, doc):
            return [self.english_stemmer.stem(t) for t in regex.sub(u" ", doc).split()]

    token = text.TfidfVectorizer(min_df=5, stop_words=list(text.ENGLISH_STOP_WORDS), decode_error='ignore', tokenizer=LemmaTokenizer())
    matrix_train = token.fit_transform(data_train.data)
    matrix_test = token.transform(data_test.data)

    return (matrix_train, matrix_test)


def TFxICF(data, categories, N):
    """
    Calculate the TFxICF coefficient of given categories.

    Input: categories - categories of interest,
    N - top N frequent terms needed.

    """

    english_stemmer = nltk.stem.SnowballStemmer('english')
    regex = re.compile('[{:s}]'.format(string.punctuation))

    class LemmaTokenizer(object):
        def __init__(self):
            self.english_stemmer = nltk.stem.SnowballStemmer('english')
        def __call__(self, doc):
            return [self.english_stemmer.stem(t) for t in regex.sub(u" ", doc).split()]

    token = text.CountVectorizer(min_df=5, stop_words=list(text.ENGLISH_STOP_WORDS), decode_error='ignore', tokenizer=LemmaTokenizer())
    X_train = token.fit_transform(data.data)
    X = X_train.toarray()

    TF = np.zeros((len(categories),len(X[0])))
    ICF = np.zeros((1,len(X[0])))
    most_freq_terms = [[],[],[],[]]

    # build the term-class matrix
    for i in range(len(X)):
        sign = data.target[i]
        TF[sign] += X[i]

    # build the ICF matrix
    for j in range(len(TF[0])):
        ICF[0][j]=scipy.log(float(len(categories))/np.count_nonzero(TF[:,j])) + 1

    TFxICF = TF*ICF

    sorted_index = np.argsort(TFxICF)
    for i in range(N):
        for j in range(len(categories)):
            most_freq_terms[j].append(str(token.get_feature_names()[sorted_index[j][-1-i]]))

    for i in range(len(categories)):
        print("Ten most significant terms in ", categories[i])
        for j in range(N):
            print('Rank '+str(j+1)+': '+str(token.get_feature_names()[sorted_index[i][-1-j]]))

    return


def lsi(data, num_feature):
    """
    Perform dimension reduction via PCA.

    Input: a matrix whose rows are the features,
    num_feature - number of features selected.
    Ouput: the leading 50 features.

    """

    U_k,S_k,V_k = scipy.sparse.linalg.svds(data.T, k = num_feature)

    return U_k

def nmf(train_data, test_data, num_feature):
    """
    Perform dimension reduction via NMF.

    Input: a matrix whose rows are the features.
    num_feature - number of features selected.
    Ouput: the leading 50 features of the training and test data.

    """

    NMF_model = NMF(n_components = num_feature, init='random', random_state=0)
    NMF_train = NMF_model.fit_transform(train_data).T
    H = NMF_model.components_
    NMF_test = H * test_data.T

    return NMF_train, NMF_test


def plot_roc(model, X_train, y_train, X_test, y_test):
    """
    Support function for plotting a ROC curve.

    Input: model - a sklearn object,
           X_train, y_train - training data and labels,
           X_test, y_test - testing data and labels.
    """

    try:
        y_predict = model.fit(X_train.T, y_train).decision_function(X_test.T)
        fpr, tpr, _ = metrics.roc_curve(y_test, y_predict)
    except:
        y_predict = model.fit(X_train.T, y_train).predict_proba(X_test.T)
        fpr, tpr, _ = metrics.roc_curve(y_test, y_predict[:,1])

    plt.figure()
    plt.plot(fpr, tpr)
    plt.plot([0, 1], [0, 1], 'k--')
    plt.xlim([0.0, 1.0])
    plt.ylim([0.0, 1.05])
    plt.xlabel('False Positive Rate')
    plt.ylabel('True Positive Rate')
    plt.title('ROC curve')
    plt.show()

    return


def plot_conf_mat(label_true, label_predict, categories = ['Computer technology', 'Recreational activity']):
    """
    Support function for ploting a normalized confusion matrix.

    Input: label_true - true label,
    label_predict - predicted labels by the underlying model.
    """

    np.set_printoptions(precision=2)
    temp = metrics.confusion_matrix(label_true, label_predict)
    conf_mat = temp.astype('float') / temp.sum(axis=1)[:, np.newaxis]

    plt.figure()
    plt.imshow(conf_mat, interpolation='nearest', cmap=plt.cm.Blues)
    plt.title('Confusion matrix')
    plt.ylabel('True label')
    plt.xlabel('Predicted label')
    plt.colorbar()
    plt.tight_layout()
    if categories == ['Computer technology', 'Recreational activity']:
        tick_marks = np.arange(2)
    else:
        tick_marks = np.arange(4)
    plt.xticks(tick_marks, categories, rotation=45)
    plt.yticks(tick_marks, categories)
    plt.show()

    print('Normalized confusion matrix')
    print(conf_mat)
    print(metrics.classification_report(label_true, label_predict, target_names=categories))

    return


def svm(X_train, y_train, X_test, y_test, gamma, flag):
    """
    Build an SVM model.

    Input: (X_train, y_train) - training data and labels,
    (X_test, y_test) - testing data and labels,
    gamma - hyperparameter (penalty) of the SVM,
    flag - a bit of flag; set to 1 if we want to plot the ROC and confusion matrix.
    """

    svm_model = SVC(C=gamma, cache_size=200, class_weight=None, coef0=0.0,
        decision_function_shape=None, degree=3, gamma='auto', kernel='rbf',
        max_iter=-1, probability=False, random_state=None, shrinking=True,
        tol=0.001, verbose=False)
    svm_model.fit(X_train.T, y_train)
    y_predict = svm_model.predict(X_test.T)

    if flag == 1:
        plot_roc(svm_model, X_train, y_train, X_test, y_test)
        plot_conf_mat(y_test, y_predict)

    return y_predict


def svm_cross_valid(X, label):
    """
    Run 5-fold cross validation to find the best penalty for soft-margin SVM.

    Input: (X, label) - training data and labels.

    """

    flag = 0
    num_val = int(np.floor(X.shape[1] // 5))
    cv_valid = X[:,0:num_val]
    cv_train = X[:,num_val:]
    label_cv_valid = label[0:num_val]
    label_cv_train = label[num_val:]

    accuracy = []
    for k in range(-3,4):
        print("Iteration k=%d" % k)

        if k == 3:
            flag = 1
        else:
            flag = 0

        y_predict = svm(cv_train, label_cv_train, cv_valid, label_cv_valid, gamma=10**k, flag=flag)
        result = float(format(metrics.accuracy_score(label_cv_valid, y_predict, '4f')))
        accuracy.append(result)

    print("Accurary for k from -3 to 4")
    print(accuracy)

    return


def svm_one(X_train, y_train, X_test, y_test, data_test, categories):
    """
    Multi-classifier SVM (one vs one)

    Input: (X_train, y_train) - training data and labels,
    (X_test, y_test) - testing data and labels.

    """

    one_vs_one_predict = OneVsOneClassifier(LinearSVC(random_state=0)).fit(X_train.T, y_train).predict(X_test.T)
    print(metrics.classification_report(data_test.target, one_vs_one_predict, target_names = data_test.target_names))
    print(metrics.confusion_matrix(data_test.target, one_vs_one_predict))
    plot_conf_mat(y_test, one_vs_one_predict, categories)

    return


def svm_rest(X_train, y_train, X_test, y_test, data_test, categories):
    """
    Multi-classifier SVM (one vs rest)

    Input: (X_train, y_train) - training data and labels,
    (X_test, y_test) - testing data and labels.

    """

    one_vs_one_predict = OneVsRestClassifier(LinearSVC(random_state=0)).fit(X_train.T, y_train).predict(X_test.T)
    print(metrics.classification_report(data_test.target, one_vs_one_predict, target_names = data_test.target_names))
    print(metrics.confusion_matrix(data_test.target, one_vs_one_predict))
    plot_conf_mat(y_test, one_vs_one_predict, categories)

    return



def naive_bayes(X_train, y_train, X_test, y_test):
    """
    Gaussian naive bayes classifier for the textual data.

    Input: (X_train, y_train) - training data and labels,
    (X_test, y_test) - testing data and labels.

    """

    nb_model = GaussianNB()
    nb_model.fit(X_train.T, y_train)
    y_predict = nb_model.predict(X_test.T)

    plot_roc(nb_model, X_train, y_train, X_test, y_test)

    plot_conf_mat(y_test, y_predict)

    return


def naive_bayes_multi(X_train, y_train, X_test, y_test, categories):
    """
    multi-Gaussian naive bayes classifier for the textual data.

    Input: (X_train, y_train) - training data and labels,
    (X_test, y_test) - testing data and labels.

    """

    nb_model = GaussianNB()
    nb_model.fit(X_train.T, y_train)
    y_predict = nb_model.predict(X_test.T)

    print(metrics.classification_report(y_test, y_predict, target_names=categories))
    print(metrics.confusion_matrix(y_test, y_predict))
    print(metrics.accuracy_score(y_test, y_predict))

    plot_conf_mat(y_test, y_predict, categories)

    return

def log_reg(X_train, y_train, X_test, y_test):
    """
    Logistic regression for the textual data.

    Input: (X_train, y_train) - training data and labels,
    (X_test, y_test) - testing data and labels.

    """

    log_reg_model = LogisticRegression(penalty='l2', dual=False, tol=0.0001, C=1.0,  solver='sag', max_iter=100)
    log_reg_model.fit(X_train.T, y_train)
    y_predict = log_reg_model.predict(X_test.T)

    plot_roc(log_reg_model, X_train, y_train, X_test, y_test)

    plot_conf_mat(y_test, y_predict)

    return


def log_reg_train(X_train, y_train, X_test, y_test, penalty, C = 1.0):
    """
    Logistic regression for the textual data.

    Input: (X_train, y_train) - training data and labels,
    (X_test, y_test) - test data and labels,
    penalty - the regularization term, 'l1' or 'l2',
    C - float, default: 1.0. Inverse of regularization strength;
    must be a positive float.
    Like in support vector machines, smaller values specify stronger regularization.

    Output: accuracy for given penalty and coefficient.

    """

    log_reg_model = LogisticRegression(penalty = penalty, dual=False, tol=0.0001, C = C, max_iter=100)
    log_reg_model.fit(X_train.T, y_train)
    y_predict = log_reg_model.predict(X_test.T)

    result = metrics.accuracy_score(y_test, y_predict)

    return float(format(result, '.4f'))


def lr_reg(X_train, y_train, X_test, y_test):
    """
    Repeat logistic regression for different penalties and coefficients.

    Input: (X_train, y_train) - training data and labels,
    (X_test, y_test) - test data and labels.

    """

    accuracy_l1 = []
    accuracy_l2 = []

    for coef in range(-3,4):
        accuracy_l1.append(log_reg_train(X_train, y_train, X_test, y_test, penalty = 'l1', C = 10**coef))
        accuracy_l2.append(log_reg_train(X_train, y_train, X_test, y_test, penalty = 'l2', C = 10**coef))

    print("Accuracy for l1 regularization:", accuracy_l1)
    print("Accuracy for l2 regularization:", accuracy_l2)

    return

