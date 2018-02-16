# import supplementary functions
from supplementary import *

def main():
    N = 10
    num_feature = 50
    data_train, data_test, label_train, label_test = load_data()

    # part (a) plot the pre-balanced data
    # plot_hist(categories, dataset)

    # part (b) modeling text data and feature extraction
    print("----------modeling text data----------")
    X_train, X_test = TFxIDF(data_train, data_test)
    print("training set: #documents: %d, #terms: %d" % (X_train.shape[0], X_train.shape[1]))
    print("test set: #documents: %d, #terms: %d" % (X_test.shape[0], X_test.shape[1]))

    # part (d) feature selection
    print("----------feature selection via LSI----------")
    U_k = lsi(X_train, num_feature)
    Dk_train = U_k.T * X_train.T
    Dk_test = U_k.T * X_test.T
    print("dim-reduced training set: # terms: %d, # docs: %d" % (Dk_train.shape[0], Dk_train.shape[1]))
    print("dim-reduced test set: # terms: %d, # docs: %d" % (Dk_test.shape[0], Dk_test.shape[1]))

    print("----------feature selection via NMF----------")
    NMF_train, NMF_test = nmf(X_train, X_test, num_feature)
    print("dim-reduced training set: # terms: %d, # docs: %d" % (NMF_train.shape[0], NMF_train.shape[1]))
    print("dim-reduced test set: # terms: %d, # docs: %d" % (NMF_test.shape[0], NMF_test.shape[1]))

    # part (e) svm
    print("----------hard-SVM model----------")
    print("Using LSI data:")
    _ = svm(Dk_train, label_train, Dk_test, label_test, gamma=1000.0, flag=1)
    print("Using NMF data:")
    _ = svm(NMF_train, label_train, NMF_test, label_test, gamma=1000.0, flag=1)

    print("----------soft-SVM model----------")
    print("Using LSI data:")
    _ = svm(Dk_train, label_train, Dk_test, label_test, gamma=0.001, flag=1)
    print("Using NMF data:")
    _ = svm(NMF_train, label_train, NMF_test, label_test, gamma=0.001, flag=1)

    # part (f) find the optimal gamma
    print("----------find the optimal gamma----------")
    print("Using LSI data:")
    svm_cross_valid(Dk_train, label_train)
    print("Using NMF data:")
    svm_cross_valid(NMF_train, label_train)

    # part (g) Gaussian naive Bayes
    print("----------Gaussian naive Bayes classifier----------")
    print("Using LSI data:")
    naive_bayes(Dk_train, label_train, Dk_test, label_test)
    print("Using NMF data:")
    naive_bayes(NMF_train, label_train, NMF_test, label_test)

    # part (h) logistic regression
    print("----------logistic regression model----------")
    print("Using LSI data:")
    log_reg(Dk_train, label_train, Dk_test, label_test)
    print("Using NMF data:")
    log_reg(NMF_train, label_train, NMF_test, label_test)

    # part (i) logistic regression with different penalties
    print("----------logistic regression with different penalties----------")
    print("Try coefficient ranging from 1e-3 to 1e4")
    print("Using LSI data:")
    lr_reg(Dk_train, label_train, Dk_test, label_test)
    print("Using NMF data:")
    lr_reg(NMF_train, label_train, NMF_test, label_test)

    # part (j) multiclass classification
    print("----------multiclass classification----------")
    categories =['comp.sys.ibm.pc.hardware' , 'comp.sys.mac.hardware', 'misc.forsale', 'soc.religion.christian']
    data_train, data_test, label_multi_train, label_multi_test = load_data_multi(categories)
    X_train, X_test = TFxIDF(data_train, data_test)
    print("training set: #documents: %d, #terms: %d" % (X_train.shape[0], X_train.shape[1]))
    print("test set: #documents: %d, #terms: %d" % (X_test.shape[0], X_test.shape[1]))

    # dimension reduction via LSI
    U_k = lsi(X_train, num_feature)
    Dk_train = U_k.T * X_train.T
    Dk_test = U_k.T * X_test.T
    print("dim-reduced training set: # terms: %d, # docs: %d" % (Dk_train.shape[0], Dk_train.shape[1]))
    print("dim-reduced test set: # terms: %d, # docs: %d" % (Dk_test.shape[0], Dk_test.shape[1]))
    multi_train, multi_test = pre_balance(Dk_train, Dk_test)

    # dimension reduction via NMF
    NMF_train, NMF_test = nmf(X_train, X_test, num_feature)
    print("dim-reduced training set: # terms: %d, # docs: %d" % (NMF_train.shape[0], NMF_train.shape[1]))
    print("dim-reduced test set: # terms: %d, # docs: %d" % (NMF_test.shape[0], NMF_test.shape[1]))
    multi_nmf_train, multi_nmf_test = pre_balance(NMF_train, NMF_test)

    print("----------naive Bayes----------")
    print("Using LSI data:")
    naive_bayes_multi(multi_train, label_multi_train, multi_test, label_multi_test, categories)
    print("Using NMF data:")
    naive_bayes_multi(multi_nmf_train, label_multi_train, multi_nmf_test, label_multi_test, categories)

    print("----------SVM (one_vs_one)----------")
    print("Using LSI data:")
    svm_one(multi_train, label_multi_train, multi_test, label_multi_test, data_test, categories)
    print("Using NMF data:")
    svm_one(multi_nmf_train, label_multi_train, multi_nmf_test, label_multi_test, data_test, categories)

    print("----------SVM (one_vs_rest)----------")
    print("Using LSI data:")
    svm_rest(multi_train, label_multi_train, multi_test, label_multi_test, data_test, categories)
    print("Using NMF data:")
    svm_rest(multi_nmf_train, label_multi_train, multi_nmf_test, label_multi_test, data_test, categories)

    print("----------TFxICF----------")
    TFxICF(data_train, categories, N)

if __name__ == "__main__":
    main()
