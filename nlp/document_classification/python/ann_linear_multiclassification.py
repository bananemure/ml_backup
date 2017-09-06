import matplotlib.pyplot as plt
from matplotlib.colors import ListedColormap
import numpy as np

# Generate three random clusters of 2D data
N_c = 200
A = 0.6*np.random.randn(N_c, 2)+[1, 1]
B = 0.6*np.random.randn(N_c, 2)+[3, 3]
C = 0.6*np.random.randn(N_c, 2)+[3, 0]
X = np.hstack((np.ones(3*N_c).reshape(3*N_c, 1), np.vstack((A, B, C))))
Y = np.vstack(((np.zeros(N_c)).reshape(N_c, 1), np.ones(N_c).reshape(N_c, 1), 2*np.ones(N_c).reshape(N_c, 1)))
K = 3
N = K*N_c

# Run gradient descent
eta = 1
max_iter = 1000
w = np.zeros((3, 3))
grad_thresh = 5 
for t in range(0, max_iter):
    grad_t = np.zeros((3, 3))
    for i in range(0, N):
        x_i = X[i, :]
        y_i = Y[i]
        exp_vals = np.exp(w.dot(x_i))
        lik = exp_vals[int(y_i)]/np.sum(exp_vals)
        grad_t[int(y_i), :] += x_i*(1-lik)

    w = w + 1/float(N)*eta*grad_t
    grad_norm = np.linalg.norm(grad_t)

    if grad_norm < grad_thresh:
        print "Converged in ",t+1,"steps."
        break

    if t == max_iter-1:
        print "Warning, did not converge."


# Begin plotting here
# Define our class colors
cmap_light = ListedColormap(['#FFAAAA', '#AAAAFF', '#AAFFAA'])

# Generate the mesh
x_min, x_max = X[:, 1].min() - 0.5, X[:, 1].max() + 0.5
y_min, y_max = X[:, 2].min() - 0.5, X[:, 2].max() + 0.5
h = 0.02 # step size in the mesh
xx, yy = np.meshgrid(np.arange(x_min, x_max, h), np.arange(y_min, y_max, h))
X_mesh = np.c_[np.ones((xx.size, 1)), xx.ravel(), yy.ravel()]
Z = np.zeros((xx.size, 1))

# Compute the likelihood of each cell in the mesh
for i in range(0, xx.size):
    lik = w.dot(X_mesh[i, :])
    Z[i] = np.argmax(lik)

# Plot it
Z = Z.reshape(xx.shape)
plt.figure()
plt.pcolormesh(xx, yy, Z, cmap=cmap_light)
plt.plot(X[0:N_c-1, 1], X[0:N_c-1, 2], 'ro', X[N_c:2*N_c-1, 1], X[N_c:2*N_c-1,
    2], 'bo', X[2*N_c:, 1], X[2*N_c:, 2], 'go')
plt.axis([np.min(X[:, 1])-0.5, np.max(X[:, 1])+0.5, np.min(X[:, 2])-0.5, np.max(X[:, 2])+0.5])
plt.show()
