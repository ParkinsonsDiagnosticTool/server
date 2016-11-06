clear ; close all; clc

%% Setup the parameters you will use 
input_layer_size  = 500;  % depends on number of entries in the file sent
hidden_layer_size = 25;   % 25 hidden units
num_labels = 2;          % 2 labels, from 1 to 2   
                          % (note that we have mapped "0" to label 2)


% Load Training Data


X=load('data.txt');
y=load('y.txt');
m = size(X, 1);


%Initializing Neural Network Parameters 

initial_Theta1 = randInitializeWeights(input_layer_size, hidden_layer_size);
initial_Theta2 = randInitializeWeights(hidden_layer_size, num_labels);

% Unroll parameters
initial_nn_params = [initial_Theta1(:) ; initial_Theta2(:)];


% Training Neural Network... 

options = optimset('MaxIter', 50);


lambda = 1;

% Create "short hand" for the cost function to be minimized
costFunction = @(p) nnCostFunction(p, ...
                                   input_layer_size, ...
                                   hidden_layer_size, ...
                                   num_labels, X, y, lambda);

[nn_params, cost] = fmincg(costFunction, initial_nn_params, options);

% Obtain Theta1 and Theta2 back from nn_params
Theta1 = reshape(nn_params(1:hidden_layer_size * (input_layer_size + 1)), ...
                 hidden_layer_size, (input_layer_size + 1));

Theta2 = reshape(nn_params((1 + (hidden_layer_size * (input_layer_size + 1))):end), ...
                 num_labels, (hidden_layer_size + 1));


pred = predict(Theta1, Theta2, X);

fprintf('\nTraining Set Accuracy: %f\n', mean(double(pred == y)) * 100);
save theta.mat Theta1 Theta2


