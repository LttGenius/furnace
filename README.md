# Furnace

<!-- PROJECT SHIELDS -->

[![Contributors][contributors-shield]][contributors-url]
[![Forks][forks-shield]][forks-url]
[![Stargazers][stars-shield]][stars-url]
[![Issues][issues-shield]][issues-url]
[![MIT License][license-shield]][license-url]
[![LinkedIn][linkedin-shield]][linkedin-url] 

<!-- PROJECT LOGO -->
<br />

<p align="center">
  <a href="https://github.com/LttGenius/furnace/">
    <img src="images/furnace.png" alt="Logo" width="80" height="80">
  </a>

  <h3 align="center">FURNACE</h3>
  <p align="center">
    An open-source tool for machine learning model
    <br />
    <a href="https://github.com/LttGenius/furnace"><strong>Download »</strong></a>
    <br />
    <br />
    <a href="https://github.com/LttGenius/furnace">Demo</a>
    ·
    <a href="https://github.com/LttGenius/furnace/issues">Bug</a>
    ·
    <a href="https://github.com/LttGenius/furnace/issues">Issues</a>
  </p>

</p>


This README.md is for machine learning researchers. 
 
## Catalogs

- [Furnace](#furnace)
  - [Catalogs](#catalogs)
    - [Guide](#guide)
        - [**Recommended configuration**](#recommended-configuration)
        - [**Installation**](#installation)
        - [**Tutorial**](#tutorial)
          - [```alchemy```](#alchemy)
          - [`racetrack`](#racetrack)
    - [Description of the document catalog](#description-of-the-document-catalog)
    - [Author](#author)
    - [Copyright](#copyright)

---

### Guide

##### **Recommended configuration**

1. MATLAB 2022b

##### **Installation**

```sh
git clone https://github.com/LttGenius/furnace.git
```
Place the folder `furnace` in your project directory. 

##### **Tutorial**

There are two main functions `alchemy` and `racetrack`. 



###### ```alchemy```
`alchemy` is utilized to search the optimal parameters of the model. 
```MATLAB
  [ best_param ] = alchemy( run_model, x, y, p_set, tunne_arg )
```
`run_model` denotes the model needs to be tunning. 
It must be formed as follows:
```matlab
res = run_model(x, y, p)
```
`x`, `y`, and `p` denote the data, label, and parameters, where the type of `p` is structure. `res` is the returned structure with keywords of *metrics*. Inside of function `alchemy`, the metrics used for comparisons are obtained by `res.(metrics)`.  The procedure for searching optimal parameters satisfies `if best_mean < res.(metrics)`.  E.g. `res.(tunne_arg.metrics) = [average, standard deviation], res.ACC = [0.99, 0.01], res.NMI = [0.99, 0.01] `

The `p_set` is the range of parameters.
E.g.
```matlab
p_set.lambda = { 1, 2, 3, 4, 5 };
p_set.gamma = { [1 1 1], [2 2 2], [3 3 3], [4 4 4], [5 5 5] }
% myModel(x, y, lambda = 1, gamma = [1 1 1])
% myModel(x, y, lambda = 2, gamma = [2 2 2])
```

The `tunne_arg` is utilized to control `alchemy`. 
The whole keywords of `tunne_arg` are as follows:
```matlab
tunne_arg = struct('logging', 'every',...
                   'show', 'every',...
                   'threshold', 0,...
                   'path','./tunneLOG.mat',...
                   'metrics','ACC',...
                   'bar','on',...
                   'index',[1 1 1],...
                   'parallel','off',
                   'parallel_thread',feature('numCores'),...
                   'save_gap',1);% default
% Parameters
% ------------
%   $ run_model $:
%     It must be of the form: `res = run_model(x, y, p)` where `x`, `y`, `p` denote data,
%     groundthruth and parameters respectively. The types of `x`, `y` and
%     `p` are cell (1 x V or V x 1), array (double) and structure,
%     respectively. 
%     The returned value (res) must be a structure with keywords of metrics ( res.(tunne_arg.metrics) = [average, standard deviation] ). E.g., res.ACC = [0.99, 0.01],
%     res.NMI = [0.99, 0.01]. 
%
%   $ tunne_arg $:
%     Arguments of ALCHEMY. Can set {'logging','show',
%     'threshold','path','metrics','bar','index','parallel','parallel_thread','save_gap'}.
%
%     `logging`: Controlling the logging of information, can be set as
%                "shutdown" (Shutdown logging); 
%                "every" (Logging everyone); 
%                "threshold" (Items which exceed the threshold are recorded); 
%                "best" (Recording when the best result is updated). 
%                The default value of 'logging' is "every". 
%     It is worth noting that if `tunne_arg.logging` is not equal to `shutdown` and `parallel` is `on`, whole information in the calculation will be recorded, causing additional memory overheads.
%     
%
%     `show`: Controlling the display of information, can be set as
%             "shutdown" (Shutdown on-screen display); 
%             "every" (Showing everyone in screen); 
%             "threshold" (Items that exceed the threshold are shown); 
%             "best" (Show when the best result is updated). 
%             The default value of 'show' is "every". 
%      It is worth noting that `tunne_arg.show` can only be selected as `shutdown`, "every" or "threshold" when `parallel` is `on`.
%
%     `threshold`: It works when `logging` or `show` is set to "threshold". | 0 (default) 
%
%     `path`: The path of logging file. Notice that it must be a mat file. | './tunneLOG.mat' (default) 
%
%     `metrics`: Metrics used for alignment {"ACC" "NMI" "Purity"  "P" "R"
%     "F" "RI" "AR", ....}. | "ACC" (default)
%   
%      `bar`: Display progress bar | "on" (default) "off"
%       Invalid when `parallel` is `on`. 
%
%      `index`: Specifying the initial parameter with index.
%
%      `parallel`: "off" (default)
%                  "on" (Enabling Parallel Computing)
%
%      `parallel_thread`: Maximum number of cores (default)
%               
%      `save_gap`: The gap of saving results of searching. The default
%      value is 1 (Every record is saved). Set to a larger value to reduce
%      consumption of IO. It is worth noting that is is invalid when
%      `parallel` is `on`. 
```
E.g.
```matlab
[x, y] = load(BBC4.mat);
%% p_set
p_set.lambda = {0.01,0.1,1,3,5,7};
p_set.gamma =  {0.01,0.1,1,3,5,10,15,20};
%% tunne_arg
tunne_arg.parallel = "on";
tunne_arg.bar = "on";
tunne_arg.parallel_thread = 8 ;
tunne_arg.save_gap = 10;
tunne_arg.metrics = 'NMI';
tunne_arg.path = './best.mat';
tunne_arg.logging = 'best';
tunne_arg.show = 'shutdown';
%% tunne
num_of_cluster = 10;
varargin = ...
[ best_param ] = alchemy( @(x, y, p)tsvdmsc(x, y, p, num_of_cluster, varargin), x, y, p_set, tunne_arg )
```

###### `racetrack`
`racetrack` is utilized to conduct the comparative experiments.
```MATLAB
  [ report ] = racetrack( methods, x, y, rules ) 
% Functional description:
% ------------------------
% Conducting comparative experiments
% 
% Formality:
% ------------------------
% methods.WTNNM = @(X, varargin)RUN_WTNNM(x, y, k, lambda, gamma, varargin{:});
% methods.KMEANS = @(X, varargin)RUN_KMEANS(x, y, k, 10, varargin{:});
% methods.myMethods = @(X, varargin)myMethod(x, y, parameters, varargin{:})
%
% X = load(Dataset_path);
%
% rules.parallel = 'on';
% rules.UnifiedCtrl = 1; % 
% rules.SpecificCtrl = {1, 2, 3}; % UnifiedCtrl and SpecificCtrl{i} will be
% used as `methods.WTNNM(X, rules.UnifiedCtrl, rules.SpecificCtrl{1})`
% 
% results = RACETRACK( methods, X, rules )
%
% Parameters
% ------------
%   $ methods $:
%     A structure with each value is a function. 
%     E.g. 
%           ` methods: 
%                     WTNNM:   RUN_WTNNM(X, varargin);
%                     KMEAMS:  RUN_KMEAMS(X, varargin)
%           `
%
%   $ X $:
%     The datasets used for the experiment.
%     Generally, `X` should contain the real data, the label and other
%     extra parameters. X is a (n x 2) cell, the first column contains names of datasets and the
%     second column contains entities of datasets. t
%
%   $ rules $:
%     Arguments of experiment (type - structure). Can set
%     {'parallel','threads','metrics', 'UnifiedCtrl', 'SpecificCtrl', 'SaveResults'， 'path_dir'}. 
%
%     `parallel`: "off"
%                 "on" 
%
%     `threads`: Maximum number of cores (default); 
%               Works only when `parallel` is "on"
%
%     `metrics`: The metrics used to compare the performance of each
%     method.
%
%     `UnifiedCtrl` and `SpecificCtrl`: the parameters used to control
%     methods. They are used as `method(data, UnifiedCtrl,
%     SpecificCtrl{index_of_method})`.
%   
%     `SaveResults`: true
%                    false
%     `path_dir`: The folder where the file is stored.
%                 ../racetrack_default_dir (default)
%
% Output
% ------------
%   Return a cell $ report $ with size num_of_datasets x num_of_methods.
%   Return a structure $ IndexOfReport $ used to get the index of `report` by
%   names of datasets and methods. 
%
%-----------------------------------------------------------------------
%|  Author: LttGenius       Version: 1.0.7      Last update: 10.12.2023|
%-----------------------------------------------------------------------
%   For more information, see <a href=
%   "https://github.com/LttGenius/furnace">LttGenius/furnace</a>.
```
---

### Description of the document catalog

```
furnace
├── LICENSE.txt
├── README.md
├── /support/
│    ├── recorder.m
│    └── show2screen.m
├── alchemy.m
└── racetrack.m

```

---

### Author

pushyu404@163.com

---

### Copyright 

For more information, please refer to [LICENSE.txt](https://github.com/LttGenius/furnace/blob/master/LICENSE.txt)

<!-- links -->
[your-project-path]:LttGenius/furnace
[contributors-shield]: https://img.shields.io/github/contributors/LttGenius/furnace.svg?style=flat-square
[contributors-url]: https://github.com/LttGenius/furnace/graphs/contributors
[forks-shield]: https://img.shields.io/github/forks/LttGenius/furnace.svg?style=flat-square
[forks-url]: https://github.com/LttGenius/furnace/network/members
[stars-shield]: https://img.shields.io/github/stars/LttGenius/furnace.svg?style=flat-square
[stars-url]: https://github.com/LttGenius/furnace/stargazers
[issues-shield]: https://img.shields.io/github/issues/LttGenius/furnace.svg?style=flat-square
[issues-url]: https://img.shields.io/github/issues/LttGenius/furnace.svg
[license-shield]: https://img.shields.io/github/license/LttGenius/furnace.svg?style=flat-square
[license-url]: https://github.com/LttGenius/furnace/blob/master/LICENSE.txt
[linkedin-shield]: https://img.shields.io/badge/-LinkedIn-black.svg?style=flat-square&logo=linkedin&colorB=555
[linkedin-url]: https://linkedin.com/in/shaojintian
