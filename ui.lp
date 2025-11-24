%%%%%%%%%%%%%%%%%%%%%%%%
% Option constants
%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%
% Window
%%%%%%%%%%%%%%%%%%%%%%%%
elem(w, window, root).
    attr(w, child_layout, flex).
    attr(w, flex_direction, row).

%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%
%table%
%%%%%%%%%%%%%%%%%%%%%%%%
%
elem(p,container, w).
    attr(p, child_layout,grid).
    attr(p, flex_direction, row).
%    attr(p, display, block).
%    attr(p, margin, auto).
    attr(p, class, ("bg-light")).

%row for attribute names that are also checkboxes for including/excluding attributes
elem(attr_name(A), checkbox, p):- attribute(A).
    attr(attr_name(A), grid_row, 1) :- attribute(A).
    attr(attr_name(A), grid_column, N+2) :- att_n(N,A).
    attr(attr_name(A), label, A) :- attribute(A).
    %styling
    attr(attr_name(A), class, ("fw-bold")) :- attribute(A).
    attr(attr_name(A), class, ("text-center")) :- attribute(A).

 

%column for the examples
elem(ex(E), label, p):- example(E,_).
    attr(ex(E), grid_row, E+1) :- example(E,_).
    attr(ex(E), grid_column, 0) :- example(E,_).
    attr(ex(E), label, E) :- example(E,_).
    attr(ex(E), class, ("fw-bold")) :- example(E,_).
    attr(ex(E), class, ("px-1")) :- example(E,_).

%column to show pos/neg label of example
elem(ex(E, V), label, p) :- example(E, V).
    attr(ex(E, V), label, V) :- example(E, V).
    attr(ex(E, V), grid_column, 1) :- example(E,V). 
    attr(ex(E, V), grid_row, E+1) :- example(E,V). 
    attr(ex(E, V), class, ("border-end")) :- example(E, V).
    attr(ex(E, V), class, ("px-1")) :- example(E, V).

%cells to show whether an example has an attribute
elem(cell(E,A), label, p) :- example(E,_), attribute(A).
    attr(cell(E,A), grid_row, E+1) :- example(E,_), attribute(A).
    attr(cell(E,A), grid_column, N+2) :- att_n(N,A), example(E,_), attribute(A).
    attr(cell(E,A), label, "X") :- has(E,A), example(E,_), attribute(A).
    attr(cell(E,A), label, "") :- not has(E,A), example(E,_), attribute(A).
    attr(cell(E,A), class, ("text-center")) :- example(E,_), attribute(A).


%column to show whether an example is correctly classified
elem(ex(E, result), label, p) :- example(E,_).
    elem(result_label, label, p).
    attr(result_label, label, "Result").
    attr(result_label, grid_column, ATT_N + 3) :- example(E,_), ATT_N = #count { 0,A : attribute(A) }.
    attr(result_label, grid_row, 0).

    attr(ex(E, result), grid_column, ATT_N + 3) :- example(E,_), ATT_N = #count { 0,A : attribute(A) }.
    attr(ex(E, result), grid_row, E+1) :- example(E,_).
    attr(ex(E, result), class, ("border-start","fw-bold")) :- example(E,_).
    attr(ex(E, result), class, ("px-1")) :- example(E,_).
    %for each example, show whether it is classified correctly or not
    attr(ex(E, result), label, "Correct") :- not failed(E), example(E,_).
    attr(ex(E, result), label, "Incorrect") :- failed(E), example(E,_).
%    attr(ex(E, result), class, ("bg-opacity-75")) :- classified(E, correct), example(E,_).
%    attr(ex(E, result), class, ("bg-danger")) :- classified(E, incorrect), example(E,_).    

% elem(ex(E,R), label, p) :- result(E,R).
%     attr(ex(E,R), label, "Result") :- result(E,R).
%     attr(ex(E,R), grid_row, E+1) :- result(E,R).
%     attr(ex(E,R), grid_column, ATT_N + 3) :- result(E,R), ATT_N = #count { 0,A : attribute(A) }.
%     attr(ex(E,R), label, "Correct") :- result(E,R), true(1,E).
%     attr(ex(E,R), label, "Incorrect") :- result(E,R), not true(1,E).

%container for the graph
elem(graph_container, container, w).
    elem(graph, canvas, graph_container).
        attr(graph, image_type, clingraph).


%%%%%%%%%%%%
% Menu bar %
%%%%%%%%%%%%

elem(menu_bar, menu_bar, w).
attr(menu_bar, title, "Propositional").
attr(menu_bar, icon, "fa-table-cells").

    %%%
    % "Clear Assumptions" Button 
    %%%
    elem(menu_bar_clear, button, menu_bar).
    attr(menu_bar_clear, label, "Clear").
    attr(menu_bar_clear, icon, "fa-trash").
    attr(menu_bar_clear, class, ("btn-outline-danger";"border-0")).
    when(menu_bar_clear, click, callback, clear_assumptions).

    %%%
    % Save Button 
    %%%
    elem(menu_bar_download, button, menu_bar).
    attr(menu_bar_download, label, "Save").
    attr(menu_bar_download, icon, "fa-save").
    % The first elements define what will be saved (in this case, only the for atoms of our formula), 
    % and the second element define the file it will be downloaded to.s
    % Any way to make this dynamic? As in, the user can chose the name of the file or which atoms to download?
    when(menu_bar_download, click, call, download("#show for/3.","instance_solution.lp")).

    %%%
    % Select solution buttons. Works automatically.
    %%%
    %elem(menu_bar_select, button, menu_bar).
    %attr(menu_bar_select, label, "Select solution").
    %attr(menu_bar_select, icon, "fa-hand-pointer").
    %when(menu_bar_select, click, callback, select).

    elem(menu_bar_next, button, menu_bar).
    attr(menu_bar_next, label, "Next").
    attr(menu_bar_next, icon, "fa-forward-step").
    when(menu_bar_next, click, callback, next_solution).

    elem(menu_bar_next_opt, button, menu_bar).
    attr(menu_bar_next_opt, label, "Next Optimal").
    attr(menu_bar_next_opt, icon, "fa-forward-step").
    when(menu_bar_next_opt, click, callback, next_solution(optN)).



%%%%%%%%%%%%%%%%%%%%%%%%%

