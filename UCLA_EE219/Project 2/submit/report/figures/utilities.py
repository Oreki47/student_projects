import sys
import numpy as np
import pandas as pd
import seaborn as sns
import matplotlib.pyplot as plt

from sklearn import metrics
from nltk import word_tokenize
from sklearn.cluster import KMeans
from sklearn.datasets import fetch_20newsgroups
from sklearn.feature_extraction import stop_words
from sklearn.decomposition import TruncatedSVD, NMF
from sklearn.feature_extraction.text import TfidfVectorizer


def load_data(split=False, reversed=False):
    """
    Load comp/recr
    cat_comp: 0, cat_recr: 1 with reversed = False.
    """

    cat_comp = ['comp.graphics', 'comp.os.ms-windows.misc', 'comp.sys.ibm.pc.hardware', 'comp.sys.mac.hardware']
    cat_recr = ['rec.autos', 'rec.motorcycles', 'rec.sport.baseball', 'rec.sport.hockey']
    categories = cat_comp + cat_recr

    if split:
        x_trn = fetch_20newsgroups(subset='train', categories=categories)
        x_tst = fetch_20newsgroups(subset='test', categories=categories)

        y_trn = [1 if x_trn.target_names[idx] in cat_recr else 0 for idx in x_trn.target]
        y_tst = [1 if x_tst.target_names[idx] in cat_recr else 0 for idx in x_tst.target]

        return x_trn.data, x_tst.data, y_trn, y_tst

    else:
        x = fetch_20newsgroups(subset='all', categories=categories)
        y = [1 if x.target_names[idx] in cat_recr else 0 for idx in x.target]

        if reversed:
            y = np.absolute(np.array(y)-1)

        return x.data, y  


def load_data_all():
    x = fetch_20newsgroups(subset='all')

    return x.data, x.target, x.target_names


def TFxIDF(x_trn, x_tst=None, min_df=3, split=False):
    """
    Conversion followed from: http://scikit-learn.org/stable/datasets/twenty_newsgroups.html


    """
    vectorizer = TfidfVectorizer(stop_words=list(stop_words.ENGLISH_STOP_WORDS), min_df=min_df)
    
    if split:
        x_trn_tfidf = vectorizer.fit_transform(x_trn)
        x_tst_tfidf = vectorizer.fit_transform(x_tst)

        return (x_trn_tfidf, x_tst_tfidf)

    else:
        x_tfidf = vectorizer.fit_transform(x_trn)

        return x_tfidf


def evaluate_results(y, y_pred, exp_name='default'):
    '''
        Print 5 measures
    '''

    print("-----------------Running %s-------------------" % exp_name)
    print("Homogeneity: %0.3f" % metrics.homogeneity_score(y, y_pred))
    print("Completeness: %0.3f" % metrics.completeness_score(y, y_pred))
    print("V-measure: %0.3f" % metrics.v_measure_score(y, y_pred))
    print("Adjusted Rand-Index: %.3f" % metrics.adjusted_rand_score(y, y_pred))
    print("Adjusted Mutual info score: %.3f" % metrics.adjusted_mutual_info_score(y, y_pred))


def reassign_class(y_pred, y_true, n_clusters=20):
    """
        Give each predicted label the mode with a greedy method
    """

    used = []
    unassigned = []
    y_rfrm = y_pred.copy()
    for label in y_pred.value_counts().index:
        try:
            assign_label = [lb for lb in y_true[y_pred==label].value_counts().index if lb not in used][0]
            used.append(assign_label)
            y_rfrm[y_pred==label] = assign_label
        except:
            unassigned.append(label)

    unused = [x for x in range(n_clusters) if x not in used]
    assert len(unassigned) == len(unused)
    
    for i, label in enumerate(unassigned):
        y_rfrm[y_pred==label] = unused[i]

    return y_rfrm.values


def kmean_wrapper(x, y, n_clusters=2, if_reassign=False):
    '''
        kmean wrapper
    '''

    km = KMeans(n_clusters=n_clusters, init='k-means++', max_iter=100, random_state=42, n_init=1)
    km.fit(x)
    y_true = pd.Series(y)
    y_pred = pd.Series(km.labels_)
    if if_reassign:
        return reassign_class(y_pred, y_true, n_clusters)
    else:
        return y_pred


def plot_color_coding(x_reduced, y_true, labels, filename, figsize=(8, 8)):
    '''
        projection of x_reduced onto a 2-dimensional space and visualize.
    '''
    if x_reduced.shape[1] > 2:
        svd = TruncatedSVD(n_components=2, n_iter=7, random_state=42)
        x_2d = svd.fit_transform(x_reduced)
    else: x_2d = x_reduced.copy()
    df = pd.DataFrame({"x": x_2d[:, 0],
                       "y": x_2d[:, 1],
                       "c": y_true})
    cmap = plt.cm.viridis

    fig = plt.figure(figsize=figsize)
    ax = fig.add_subplot(111)

    for i, sub in df.groupby('c'):
        ax.scatter(sub['x'], sub['y'], c=cmap(1.*i/len(labels)), s=2, 
                    edgecolors='none', label=labels[i])

    ax.set_xlabel("First component")
    ax.set_ylabel("Second component")
    lgnd = ax.legend()
    for handle in lgnd.legendHandles:
        handle.set_sizes([24.0])
    fig.tight_layout()
    fig.savefig(filename, dpi=200)


def rs_wrapper(rs, x, y_true, method='svd', n_clusters=2, if_reassign=False,
               plot_5measures=True, five_measure_name='default_5measures',
               plot_cont=False, cont_name='default_cont', label=None, annot=True,
               five_measure_size=(12, 9), cont_size=(12, 12), x_rotation=0):
    '''
        multiple num_components wrapper
    '''
    best_r = None
    best_v = 0
    homogeneity = []
    completeness = []
    v_measure = []
    adjusted_rand= []
    adjusted_mutual_info = []
    contingency_matrics = []

    for i, r in enumerate(rs):
        print('iter ', i)
        if method=='svd':
            svd = TruncatedSVD(n_components=r, n_iter=7, random_state=42)
            x_reduced = svd.fit_transform(x)
        else:
            nmf = NMF(n_components=r, random_state=42)
            x_reduced = nmf.fit_transform(x)

        y_pred = kmean_wrapper(x_reduced, y_true, n_clusters, if_reassign)
        contingency_matrics.append(metrics.confusion_matrix(y_true, y_pred))
        homogeneity.append(metrics.homogeneity_score(y_true, y_pred))
        completeness.append(metrics.completeness_score(y_true, y_pred))
        v_measure.append(metrics.v_measure_score(y_true, y_pred))
        adjusted_rand.append(metrics.adjusted_rand_score(y_true, y_pred))
        adjusted_mutual_info.append(metrics.adjusted_mutual_info_score(y_true, y_pred))

        if best_v < v_measure[-1]:
            best_v = v_measure[-1]
            best_r = r

    print('fitting completed')
    if method=='svd':
        svd = TruncatedSVD(n_components=best_r, n_iter=7, random_state=42)
        x_reduced = svd.fit_transform(x)
    else:
        nmf = NMF(n_components=best_r, random_state=42)
        x_reduced = nmf.fit_transform(x)
    y_pred = kmean_wrapper(x_reduced, y_true, n_clusters, if_reassign)
    evaluate_results(y_true, y_pred, 'best_r: '+ str(best_r))

    if plot_5measures:
        measures = [homogeneity, completeness, v_measure, adjusted_rand, adjusted_mutual_info]
        plot_5_measures(rs, measures, five_measure_name, five_measure_size)
    if plot_cont:
        plot_cont_matrix(rs, contingency_matrics, cont_name, label, annot, cont_size, x_rotation)


def plot_5_measures(rs, measures, five_measure_name, figsize=(12, 9)):
    '''
        Given lists of 5 measures, plot.
    '''
    
    ylabels = ['Homogeneity score', 'Completness score', 'V measure score',
               'Adjusted rand score', 'Adjusted mutual info score']

    fig = plt.figure(figsize=figsize)
    for i, measure in enumerate(measures):
        ax = fig.add_subplot(2, 3, i+1)
        ax.plot(rs, measure)
        ax.set_xlabel('Number of components')
        ax.set_ylabel(ylabels[i])
        ax.grid('on')

    fig.tight_layout()
    fig.savefig(five_measure_name, dpi=300)


def plot_cont_matrix(rs, contingency_matrics, cont_name, label, annot=True, figsize=(8, 8), x_rotation=0):
    '''
        Given a list of cont_matrix, plot
    '''

    fig = plt.figure(figsize=figsize)
    for i, contingency_matrix in enumerate(contingency_matrics):
        ax = fig.add_subplot(3, 3, i+1)
        ax = sns.heatmap(contingency_matrix, cmap='GnBu', cbar=False, annot=True, fmt='d')
        ax.set_xticklabels(label, rotation=x_rotation)
        ax.set_yticklabels(label, rotation=0)
        ax.set_xlabel('Predicted State')
        ax.set_ylabel('Actual State')
        title = "r= %i" % rs[i]
        ax.set_title(title)

    fig.tight_layout()
    fig.savefig(cont_name, dpi=300)