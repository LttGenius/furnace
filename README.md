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
  <a href="https://github.com/xinyu-pu/furnace/">
    <img src="images/furnace.png" alt="Logo" width="80" height="80">
  </a>

  <h3 align="center">FURNACE</h3>
  <p align="center">
    An open-source tool for machine learning model
    <br />
    <a href="https://github.com/xinyu-pu/furnace"><strong>Download »</strong></a>
    <br />
    <br />
    <a href="https://github.com/xinyu-pu/furnace">Demo</a>
    ·
    <a href="https://github.com/xinyu-pu/furnace/issues">Bug</a>
    ·
    <a href="https://github.com/xinyu-pu/furnace/issues">Issues</a>
  </p>

</p>


This README.md is for machine learning researchers. 

- [Furnace](#furnace)
  - [Guides](#guides)
        - [**Recommended configuration**](#recommended-configuration)
        - [**Installation**](#installation)
        - [**Introduction**](#introduction)
        - [Properties](#properties)
        - [Methods](#methods)
  - [Author](#author)
  - [Copyright](#copyright)

---

## Guides

##### **Recommended configuration**

1. MATLAB 2022b

##### **Installation**

```sh
git clone https://github.com/xinyu-pu/furnace.git
```
Place the folder `furnace` in your project directory. 

##### **Introduction**
Class `furnace` conducts comparative experiments or grid searches. Furthermore, The `furnace` can covert results to $\LaTeX$ table. 

##### <font color=#CD5C5C>Properties</font>
- <details>
  <summary><font color=#9400D3>datasets - cell of datasets</font></summary>
  Type: cell

  Size: $n \times 3$
  
  - The first column is the tag of certain datasets.
  - The second column is the name of the datasets.
  - The third column is the path or real value of datasets. 

  Example: 
  ```matlab
  >> datasets
    data =

  3×3 cell array

    {[1]}    {'3source' }    {'Dataset\3source_Per0.mat' }
    {[2]}    {'bbcsport'}    {'Dataset\bbcsport_Per0.mat'}
    {[3]}    {'Caltech7'}    {'Dataset\Caltech7_Per0.mat'}
  
  ```
  </details>
- <details><summary><font color=#9400D3>models - cell of models</font></summary>
  Type: cell

  Size: $n \times 3$

  - The first column is the tag of certain models.
  - The second column is the name of the models.
  - The third column is the function handle of models. 
  
  Example: 
  ```matlab
  >> models
    models =

  3×3 cell array

    {[1]}    {'RWLTA' }    {@runRWLTA}
    {[2]}    {'PGP'}       {@runPGP}
    {[3]}    {'Kmeans'}    {@runKmeans}
  
  ```

  In addition, the formality of each model is as follows, 
  ```matlab
  function Results = function_name(data, uCtrl, mysCtrl)
    X = data.X;
    gt = data.gt;

    AllDatasetsNames = uCtrl;
    Parameters = mysCtrl;

  end
  ```
  where ```uCtrl``` is a global parameter, that is the same in all models. The ```mysCtrl``` is specific parameter, that is an element of ```sCtrl```, where ```sCtrl``` is a $n\times 1$ cell, $n$ is the number of models. 
  </details>
- <details><summary><font color=#9400D3>status - Runtime Status</font></summary>
  Type: numeric



  Example: 
  ```ans = 0``` denotes the example of furnace has not yet performed `compara` or `gridsearch`. 

  ```ans = 3``` denotes the example has performed `compara`. 

  ```ans = 2``` denotes the example has performed `gridsearch`. 

  </details>
- <details><summary><font color=#9400D3>InputParameters - Input parameter logging</font></summary>
  Type: Structure

  Fields: 
  - InputsFlags (A $6\times 1$ array, indicates whether the following parameters are passed in)
  - ParallelThread (An integer, that denotes the used cores for running in parallel)
  - metrics (A cell, that denotes the field values used for printouts.)
  - uCtrl (Unified control parameter.)
  - sCtrl (A cell, specific control parameter.)
  - SavePath (The path to save single-step results.)
  - ShowBar (If it is given, the `waitbor` is valid. )
  </details>
- <details><summary><font color=#9400D3>ReportTable - Table</font></summary>
  Type: Table

  Size: $n\times m$, where $n$ and m are the numbers of models and datasets, respectively. 

  Example: 
  ```matlab
  >> ReportTable
  ReportTable =

  3×3 table

                   3source       bbcsport      Caltech7 
                  __________    __________    __________

    FastPGP_g1    1×1 struct    1×1 struct    1×1 struct
    FastPGP_g2    1×1 struct    1×1 struct    1×1 struct
    FastPGP_g3    1×1 struct    1×1 struct    1×1 struct
    
  ```
  </details>

##### <font color=#CD5C5C>Methods</font>
- <details>
  <summary><font color=#9400D3>furnace</font></summary>
  Creating an instance. 

  Example:
  ```matlab
  exa = furnace( datasets, models )
  exa = furnace(  )
  ```
  `datasets` and `models` are cells (n x 3). The first, second, and third columns are tag, name, and data (path, numerical, or function_hanle). E.g.

  ```matlab
  >> datasets
   3x3 cell
    {[1]}    {'3source' }    {'Dataset\3source_Per0.mat' }
    {[2]}    {'bbcsport'}    {'Dataset\bbcsport_Per0.mat'}
    {[3]}    {'Caltech7'}    {'Dataset\Caltech7_Per0.mat'}


  >> models
    models =

  3×3 cell array

    {[1]}    {'RWLTA' }    {@runRWLTA}
    {[2]}    {'PGP'}       {@runPGP}
    {[3]}    {'Kmeans'}    {@runKmeans}
  ```
  Note that the following `compara` and `gridsearch` depend on `datasets` and `models`. If you want to run `compara` or `gridsearch`, `furnace( datasets, models )` is required. 
  </details>
- <details>
  <summary><font color=#9400D3>compara</font></summary>
  Conducting comparative experiments. 

  Example:
  <details>
  <summary><font color=#9400D3><code>[ Performance ] = exa.compara()</code></font></summary>
  It performs comparative experiments on all datasets for all models in serial. 
  </details>

  <details>
  <summary><font color=#9400D3><code>[ Performance ] = exa.compara('parallel', NUMBER_OF_CORES)</code></font></summary>
  It performs comparative experiments on all datasets for all datasets in parallel with `NUMBER_OF_CORES` thread. `NUMBER_OF_CORES` is 
  optional, if `NUMBER_OF_CORES` is absent, the number of threads is the
  maximum number of cores. 
  </details>

  <details>
  <summary><font color=#9400D3><code>[ Performance ] = exa.compara( __, 'print', { ... } )</code></font></summary>
  It enables Print-to-Screen. The following `{ ... }` is a cell with each element denoting the displayed fields. E.g. 
  <code>exa.compara( __, 'print', { "acc", "nmi" } )
  >> Epoch: 1/200, Model: RWLTA, Dataset: 3source<br />
  >> acc: 98.21   0<br />
  >> nmi: 97.13   0
  </code>
  </details>
  
  <details>
  <summary><font color=#9400D3><code>[ Performance ] = exa.compara( __, 'uCtrl', uCtrl )</code></font></summary>
  It transmits <code>uCtrl</code> into<code> function_handle(data, uCtrl, sCtrl{i})</code> 
  </details>

  <details>
  <summary><font color=#9400D3><code>[ Performance ] = exa.compara( __, 'sCtrl', sCtrl )</code></font></summary>
  It transmits <code>sCtrl{i}</code> into<code> function_handle(data, uCtrl, sCtrl{i})</code> 
  </details>

  <details>
  <summary><font color=#9400D3><code>[ Performance ] = exa.compara( __, 'savepath', '...' )</code></font></summary>
  It can save the results of each step. The '...' is the path to save. 
  </details>

  <details>
  <summary><font color=#9400D3><code>[ Performance ] = exa.compara( __, 'waitbar' )</code></font></summary>
  It enables the waitbar. 
  </details>

  </details>
- <details>
  <summary><font color=#9400D3>gridsearch</font></summary>
  Conducting grid search on a certain model. Different from <code>exa.compara</code>, <code>exa.gridsearch</code> requires an extra parameter <code>ParameterSet</code>. The <code>ParameterSet</code> is a structure, containing sets of parameters, e.g. <br /><code>ParameterSet.lambda = { ... };<br />
    ParameterSet.gamma =  { ... };<br />
    ParameterSet.mu = { ... };</code>
  Addtitonly, for <code>exa.gridsearch</code>, the <code>models</code> in <code>furnace(dataset, models)</code> must be a $1\times 3$ cell, e.g.</br>
  <code>
  models =

  1×3 cell array

    {[1]}    {'RWLTA'}    {@runRWLTA}
  </code>
  Once <code>exa.gridsearch</code> executed, multiple models are automatically generated based on the combination of parameters, referred to as `ModelName_gi`. For grid searches, <code>sCtrl</code> is invalid due to <code>exa.gridsearch</code> sets the inputting parameters as <code>sCtrl</code>. Therefore, for <code>exa.gridsearch</code>, the formality of <code>model</code> is as follows
  <code>
  function results = runModel(data, uCtrl, Parameters)
    lambda = Parameters.lambda;
    gamma = Parameters.gamma;
  end
  </code>

  Example:
  <details>
  <summary><font color=#9400D3><code>[ Performance ] = exa.gridsearch( ParameterSet )</code></font></summary>
  It performs grid searches on all datasets for one model in serial. 
  </details>

  <details>
  <summary><font color=#9400D3><code>[ Performance ] = exa.gridsearch( __, 'parallel', NUMBER_OF_CORES)</code></font></summary>
  It performs grid searches on all datasets for one model in parallel with `NUMBER_OF_CORES` thread. `NUMBER_OF_CORES` is 
  optional, if `NUMBER_OF_CORES` is absent, the number of threads is the
  maximum number of cores. 
  </details>

  <details>
  <summary><font color=#9400D3><code>[ Performance ] = exa.gridsearch( __, 'print', { ... } )</code></font></summary>
  It enables Print-to-Screen. The following `{ ... }` is a cell with each element denoting the displayed fields. E.g. 
  <code>exa.gridsearch( __, 'print', { "acc", "nmi" } )
  >> Epoch: 1/200, Model: RWLTA, Dataset: 3source<br />
  >> acc: 98.21   0<br />
  >> nmi: 97.13   0
  </code>
  </details>
  
  <details>
  <summary><font color=#9400D3><code>[ Performance ] = exa.gridsearch( __, 'uCtrl', uCtrl )</code></font></summary>
  It transmits <code>uCtrl</code> into<code> function_handle(data, uCtrl, sCtrl{i})</code> 
  </details>

  <details>
  <summary><font color=#9400D3><code>[ Performance ] = exa.gridsearch( __, 'sCtrl', sCtrl )</code></font></summary>
  It transmits <code>sCtrl{i}</code> into<code> function_handle(data, uCtrl, sCtrl{i})</code> 
  </details>

  <details>
  <summary><font color=#9400D3><code>[ Performance ] = exa.gridsearch( __, 'savepath', '...' )</code></font></summary>
  It can save the results of each step. The '...' is the path to save. 
  </details>

  <details>
  <summary><font color=#9400D3><code>[ Performance ] = exa.gridsearch( __, 'waitbar' )</code></font></summary>
  It enables the waitbar. 
  </details>

  </details>
- <details>
  <summary><font color=#9400D3>getlatextable</font></summary>

  Transmits the ReportTable to $\LaTeX$ table. E.g., the original $\LaTeX$ style table is 
  ```
    \begin{table}[ht]
      \centering
      \begin{tabular}{*{3}{c}}
          \hline
          Models & Data1 & Data1 \\
          \hline
          Model1 & furnace.FastPGP_g1.3source.acc & furnace.FastPGP_g1.bbcsport.acc\\
          Model2 & furnace.FastPGP_g2.3source.acc & furnace.FastPGP_g2.bbcsport.acc\\
          \hline
      \end{tabular}
  \end{table}
  ```
  `getlatextable` can replace `furnace.FastPGP_g1.3source.acc` to a real value. 
  Furthermore, `Model1` and `Data1` can also be replaced. 

  The symbolic placeholder of $\LaTeX$ style table consists of prompt string `furnace`, name of models, e.g. `FastPGP_g1`, name of datasets, e.g. `3source`, and field of results, e.g. `acc`. They are linked by the separator `.`. If `Model1` or `Data1` needs to be replaced, please give parameters `modelnickname` or `datanickname`, respectively. 

  Example:
    <details>
    <summary><font color=#9400D3><code>[ filetext ] = exa.getlatextable(FormatFile, 'format', '...')</code></font></summary>.
    FormatFile is a text file that contains the $\LaTeX$ Table Style.
    The 'format' indicates the format of the output string as shown in the following '...', E.g. '%.2f(%.2f)'.
    </details>

    <details>
    <summary><font color=#9400D3><code>[ filetext ] = exa.getlatextable( __, 'optimal', {"...", ...},'metrics', {"...", ...},'analysis', @function).</code></font></summary>.
    It sorts the values of fields indicated by `'metrics', {"...", ...}` in descending order, and replaces them with styles from `'optimal', {"...", ...}` in order. The `'analysis', @function` is the function for conducting sorting. If `'analysis', @function` is absent, the default function is as follows. 

    ```matlab
    function [ ResultMap ] = dataanalysis( data, keys )
      %dataanalysis Default sort
      [NModels, NDatasets] = size(data);
      Nkeys = numel(keys);
      ResultMap = zeros(NModels, NDatasets, Nkeys);
      TempMap = zeros(NModels, NDatasets, Nkeys);
      % Get optimal model for each dataset. 
      for iData = 1:NDatasets
          for iModel = 1:NModels
              r = data{iModel, iData};
              for iKey = 1:Nkeys
                  m = r.(keys{iKey});
                  if numel(m) > 1
                      TempMap(iModel, iData, iKey) = m(1);
                  else
                      TempMap(iModel, iData, iKey) = m;
                  end
              end
          end
      end
      [ ~, SortIndex ] = sort(TempMap, 1, 'descend');
      for iData = 1:NDatasets
          for iModel = 1:NModels
              for iKey = 1:Nkeys
                  t = SortIndex(iModel, iData, iKey);
                  ResultMap(t, iData, iKey) = iModel;
              end
          end
      end
      end
  ```
    </details>

    <details>
    <summary><font color=#9400D3><code>[ filetext ] = exa.getlatextable( __, 'datanickname', {'...', '...'; ...} )</code></font></summary>.
    It will replace dataset names. E.g. {'Data1', '3source'; 'Data2', 'ORL'}, it replaces 'Data1' by '3source'. 
    </details>

    <details>
    <summary><font color=#9400D3><code>[ filetext ] = exa.getlatextable( __, 'modelnickname', {'...', '...'; ...} )</code></font></summary>.
    It will replace model names. 
    </details>

    <details>
    <summary><font color=#9400D3><code>[ filetext ] = exa.getlatextable( __, 'source', '...' )</code></font></summary>.
    It will load data from '...'. If `exa.compara` or `exa.gridsearch` is not executed before, 'source' and '...' must be given.
    </details>

    <details>
    <summary><font color=#9400D3><code>[ filetext ] = exa.getlatextable( __, 'savepath', '...' )</code></font></summary>.
    It saves the results in path '...'.
    </details>
  
  </details>

---

## Author

pushyu404@163.com

---

## Copyright 

For more information, please refer to [LICENSE.txt](https://github.com/xinyu-pu/furnace/blob/master/LICENSE.txt)

<!-- links -->
[your-project-path]:xinyu-pu/furnace
[contributors-shield]: https://img.shields.io/github/contributors/xinyu-pu/furnace.svg?style=flat-square
[contributors-url]: https://github.com/xinyu-pu/furnace/graphs/contributors
[forks-shield]: https://img.shields.io/github/forks/xinyu-pu/furnace.svg?style=flat-square
[forks-url]: https://github.com/xinyu-pu/furnace/network/members
[stars-shield]: https://img.shields.io/github/stars/xinyu-pu/furnace.svg?style=flat-square
[stars-url]: https://github.com/xinyu-pu/furnace/stargazers
[issues-shield]: https://img.shields.io/github/issues/xinyu-pu/furnace.svg?style=flat-square
[issues-url]: https://img.shields.io/github/issues/xinyu-pu/furnace.svg
[license-shield]: https://img.shields.io/github/license/xinyu-pu/furnace.svg?style=flat-square
[license-url]: https://github.com/xinyu-pu/furnace/blob/master/LICENSE.txt
[linkedin-shield]: https://img.shields.io/badge/-LinkedIn-black.svg?style=flat-square&logo=linkedin&colorB=555
[linkedin-url]: https://linkedin.com/in/shaojintian
