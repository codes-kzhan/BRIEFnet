classdef BRIEF < dagnn.Filter
  properties
    size = [0 0 0 0]
    hasBias = false
    opts = {''}
  end

  methods
    function outputs = forward(obj, inputs, params)
        outputs = extract_brief(inputs, params);
    end

    function [derInputs, derParams] = backward(obj, inputs, params, derOutputs)
      %{
        if ~obj.hasBias, params{2} = [] ; end
      [derInputs{1}, derParams{1}, derParams{2}] = vl_nnconv(...
        inputs{1}, params{1}, params{2}, derOutputs{1}, ...
        'pad', obj.pad, ...
        'stride', obj.stride, ...
        'dilate', obj.dilate, ...
        obj.opts{:}) ;
        %}
    end

    function kernelSize = getKernelSize(obj)
      %kernelSize = obj.size(1:2) ;
    end

    function outputSizes = getOutputSizes(obj, inputSizes)
      %outputSizes = getOutputSizes@dagnn.Filter(obj, inputSizes) ;
      %outputSizes{1}(3) = obj.size(4) ;
    end

    function params = initParams(obj)
      %sc = sqrt(2 / prod(obj.size(1:3))) ;
      % Xavier improved
      %{
      sc = sqrt(2 / prod(obj.size([1 2 4]))) ;
      params{1} = randn(obj.size,'single') * sc ;
      if obj.hasBias
        params{2} = zeros(obj.size(4),1,'single') ;
      end
      %}
    end

    function set.size(obj, ksize)
      % make sure that ksize has 4 dimensions
      %ksize = [ksize(:)' 1 1 1 1] ;
      %obj.size = ksize(1:4) ;
    end

    %function obj = Conv(varargin)
    %  obj.load(varargin) ;
      % normalize field by implicitly calling setters defined in
      % dagnn.Filter and here
    %  obj.size = obj.size ;
    %  obj.stride = obj.stride ;
    %  obj.pad = obj.pad ;
    %end
  end
end
