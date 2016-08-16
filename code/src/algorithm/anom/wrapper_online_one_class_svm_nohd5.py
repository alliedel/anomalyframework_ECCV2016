import argparse
#import h5py
import numpy as np
import scipy.io as scio
import pdb as pdb
import os as os
import online_one_class_svm as oocs
import sys

def main(runfile):
    
    pars = parseRunfile(runfile)
    
    default_fn_file = '../../../data/input/features/subway/subway_exit_turnstiles/subway_exit_turnstiles_all_white_1_kmeans_all_K_50_BOV_hard_histNorm_none_fn.mat'
    default_gt_file = '../../../data/input/videos/subway/subway_exit_gt.mat'

#    pdb.set_trace()

    fname=pars['featsfile']
    print fname
    X = np.loadtxt(fname,delimiter=',')
#    f = h5py.File(pars['featsfile']); # If this breaks, try saving the MATLAB file with -v7.3
#    X = np.asarray(f['fn']).transpose()
 #   pdb.set_trace()

#    d=scio.loadmat()
#    gt=d['binaryGT']
#    gt[gt > 0] = 1
#    y = gt

    shuffle_inds = np.asarray(range(X.shape[0]))
#    shuffle_inds = shuffle_inds[::-1]

    # numpy.random.shuffle(shuffle_inds)  

    X = X[shuffle_inds, :]

    print np.shape(X)

    ocn = oocs.one_class_norma(nu = pars['nu'], lam = pars['lam'], eta = pars['eta'], kernel_params = {'sigma' : pars['sigma_ocn']}, stopmodelframe=pars['stopmodelframe'])
    y_p, rhos = ocn.evaluate(X, np.zeros((X.shape[0], 1)))

    y_p_fixed = np.zeros_like(y_p)
    y_p_fixed[shuffle_inds] = y_p

    rhos_fixed = np.zeros_like(rhos)
    rhos_fixed[shuffle_inds] = rhos

#    y_hat = (y_p_fixed <= rhos_fixed).ravel()
    np.savetxt(pars['outfile'],y_p_fixed)
#    np.savetxt(pars['outfile'] + '2',1-y_p)
    
#    plt.plot(range(y_p.shape[0]), y_p_fixed)
#    plt.plot(range(rhos.shape[0]), rhos_fixed)
#    plt.show(block = False)
#    pdb.set_trace()





def parseRunfile(runfile):
    from ConfigParser import SafeConfigParser
    parser = SafeConfigParser()
    parser.read(runfile)
    d = {}
    listofparsedvars = parser.items('DEFAULT')
    for i in range(len(listofparsedvars)):
        val = listofparsedvars[i][1]
        if val.isdigit():
            val = float(val)
            print val
        try:
            val = float(val)
        except ValueError:
            print "Not a float"
        nm = listofparsedvars[i][0]
        d[nm] = val
    return d

if __name__ == "__main__":
    main(sys.argv[1])

