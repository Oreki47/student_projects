function submit()
  addpath('./lib');

  conf.assignmentSlug = 'multi-class-classification-and-neural-networks';
  conf.itemName = 'Multi-class Classification and Neural Networks';
  conf.partArrays = { ...
    { ...
      '1', ...
      { 'lrCostFunction.m' }, ...
      'Regularized Logistic Regression', ...
    }, ...
    { ...
      '2', ...
      { 'oneVsAll.m' }, ...
      'One-vs-All Classifier Training', ...u
    }, ...
    { ...
      '3', ...
      { 'predictOneVsAll.m' }, ...
      'One-vs-All Classifier Prediction', ...
    }, ...
    { ...
      '4', ...
      { 'predict.m' }, ...
      'Neural Network Prediction Function' ...
    }, ...
  };
  conf.output = @output;

  submitWithConfiguration(conf);
end

function out = output(partId, auxdata)
  % Random Test Cases
  X = [ones(20,1) (exp(1) * sin(1:1:20))' (exp(0.5) * cos(1:1:20))'];
  y = sin(X(:,1) + X(:,2)) > 0;
  Xm = [ -1 -1 ; -1 -2 ; -2 -1 ; -2 -2 ; ...
          1 1 ;  1 2 ;  2 1 ; 2 2 ; ...
         -1 1 ;  -1 2 ;  -2 1 ; -2 2 ; ...
          1 -1 ; 1 -2 ;  -2 -1 ; -2 -2 ];
  ym = [ 1 1 1 1 2 2 2 2 3 3 3 3 4 4 4 4 ]';
  t1 = sin(reshape(1:2:24, 4, 3));
  t2 = cos(reshape(1:2:40, 4, 5));

  if partId == '1'
    [J, grad] = lrCostFunction([0.25 0.5 -0.5]', X, y, 0.1);
    out = sprintf('%0.5f ', J);
    out = [out sprintf('%0.5f ', grad)];
  elseif partId == '2'
    out = sprintf('%0.5f ', oneVsAll(Xm, ym, 4, 0.1));
  elseif partId == '3'
    out = sprintf('%0.5f ', predictOneVsAll(t1, Xm));
  elseif partId == '4'
    out = sprintf('%0.5f ', predict(t1, t2, Xm));
  end 
end
