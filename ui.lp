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

%row for attribute names
elem(attr_name(A), label, p):- attribute(A).
    attr(attr_name(A), grid_row, 1) :- attribute(A).
    attr(attr_name(A), grid_column, N+2) :- att_n(N,A).
    attr(attr_name(A), label, A) :- attribute(A).
    %styling
    attr(attr_name(A), class, ("fw-bold")) :- attribute(A).
    attr(attr_name(A), class, ("text-center")) :- attribute(A).

%rows to force include/exclude attributes
%force label
elem(force_label, label, p).
    attr(force_label, label, "Include").
    attr(force_label, grid_row, 2).
    attr(force_label, grid_column, 1).
    attr(force_label, class, ("fw-bold")).
    attr(force_label, class, ("pe-2")).
%force checkboxes
elem(force_a(A), checkbox, p):- attribute(A).
    attr(force_a(A), grid_row, 2) :- attribute(A).
    attr(force_a(A), grid_column, N+2) :- att_n(N,A).
    attr(force_a(A), checked, true) :- include(A).
%exclude label
elem(exclude_label, label, p).
    attr(exclude_label, label, "Exclude").
    attr(exclude_label, grid_row, 3).
    attr(exclude_label, grid_column, 1).
    attr(exclude_label, class, ("fw-bold")).
    attr(exclude_label, class, ("pe-2")).
%exclude checkboxes
elem(exclude_a(A), checkbox, p):- attribute(A).
    attr(exclude_a(A), grid_row, 3) :- attribute(A).
    attr(exclude_a(A), grid_column, N+2) :- att_n(N,A).
    attr(exclude_a(A), checked, true) :- exclude(A).
%actions
when(force_a(A), click, call, add_atom(include(A))) :- attribute(A), not include(A).
when(force_a(A), click, call, remove_atom(exclude(A))) :- exclude(A).
when(force_a(A), click, call, remove_atom(include(A))) :- attribute(A), include(A).
when(exclude_a(A), click, call, add_atom(exclude(A))) :- attribute(A), not exclude(A).
when(exclude_a(A), click, call, remove_atom(include(A))) :- include(A).
when(exclude_a(A), click, call, remove_atom(exclude(A))) :- attribute(A), exclude(A).


 
%column for the examples
elem(ex(E), label, p):- example(E,_).
    attr(ex(E), grid_row, E+4) :- example(E,_).
    attr(ex(E), grid_column, 0) :- example(E,_).
    attr(ex(E), label, E) :- example(E,_).
    attr(ex(E), class, ("fw-bold")) :- example(E,_).
    attr(ex(E), class, ("px-1")) :- example(E,_).

%column to show pos/neg label of example, should start in the row after the include/exclude buttons
elem(ex(E, V), label, p) :- example(E, V).
    attr(ex(E, V), label, V) :- example(E, V).
    attr(ex(E, V), grid_column, 1) :- example(E,V). 
    attr(ex(E, V), grid_row, E+4) :- example(E,V). 
    attr(ex(E, V), class, ("border-end")) :- example(E, V).
    attr(ex(E, V), class, ("px-1")) :- example(E, V).

%cells to show whether an example has an attribute
elem(cell(E,A), label, p) :- example(E,_), attribute(A).
    attr(cell(E,A), grid_row, E+4) :- example(E,_), attribute(A).
    attr(cell(E,A), grid_column, N+2) :- att_n(N,A), example(E,_), attribute(A).
    attr(cell(E,A), label, "X") :- has(E,A), example(E,_), attribute(A).
    attr(cell(E,A), label, "") :- not has(E,A), example(E,_), attribute(A).
    attr(cell(E,A), class, ("text-center")) :- example(E,_), attribute(A).


%column to show whether an example is correctly classified
elem(ex(E, result), label, p) :- example(E,_).
    elem(result_label, label, p).
    attr(result_label, label, "Result").
    attr(result_label, grid_column, ATT_N + 3) :- example(E,_), ATT_N = #count { 0,A : attribute(A) }.
    attr(result_label, grid_row, 3).
    %styling
    attr(result_label, class, ("fw-bold")).
    attr(result_label, class, ("text-center")).

    attr(ex(E, result), grid_column, ATT_N + 3) :- example(E,_), ATT_N = #count { 0,A : attribute(A) }.
    attr(ex(E, result), grid_row, E+4) :- example(E,_).
    %for each example, show whether it is classified correctly or not
    attr(ex(E, result), label, "Correct") :- not failed(E), example(E,_).
    attr(ex(E, result), label, "Incorrect") :- failed(E), example(E,_).
    %styling
    attr(ex(E, result), class, ("text-center")) :- example(E,_).
    attr(ex(E, result), class, ("text-success")) :- example(E,_), not failed(E).
    attr(ex(E, result), class, ("text-danger")) :- example(E,_), failed(E).



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

