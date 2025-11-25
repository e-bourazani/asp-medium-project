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
    attr(menu_bar_clear, label, "Restart").
    attr(menu_bar_clear, icon, "fa-trash").
    attr(menu_bar_clear, class, ("btn-outline-danger";"border-0")).
    when(menu_bar_clear, click, callback, restart).

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

% Create a button for setting the max/min error of the formula.
    elem(menu_bar_size, button, menu_bar).
    attr(menu_bar_size, label, "Set Size").
    when(menu_bar_size, click, update, (set_size,visibility,visible)).

% When the button is clicked, show a modal where the user can set a new size constant.
    
    elem(set_size,modal,w).
    attr(set_size,title,"Size").

    elem(set_size_container, container, set_size).
    attr(set_size_container, flex_direction, "column").
    attr(set_size_container, class, "align-items-end").

    % Add button to apply new size
    elem(set_size_button, button, set_size_container).
    attr(set_size_button, label, "Apply").
    attr(set_size_button, class, "m-1").
    attr(set_size_button, class, "btn-success").


    when(set_size_button, click, call, 
        (
            remove_atom(max_size(M)),
            remove_atom(min_size(M)),
            add_atom(maximum_size(_context_value(new_max_size))),
            add_atom(minimum_size(_context_value(new_min_size))))
        )
            :-
                max_size(M), min_size(M).

    % You get two textfields so the user can set a new number.
    elem(max_size, textfield, set_size_container).
    attr(max_size, placeholder, "Set max size").
    attr(max_size, width, 450).
    when(max_size, input, context, (new_max_size, _value)).

    elem(min_size, textfield, set_size_container).
    attr(min_size, placeholder, "Set min size").
    attr(min_size, width, 450).
    when(min_size, input, context, (new_min_size, _value)).


   
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Create a button for setting the max/min error of the formula.
    elem(menu_bar_error, button, menu_bar).
    attr(menu_bar_error, label, "Set Error").
    when(menu_bar_error, click, update, (set_error,visibility,visible)).

% When the button is clicked, show a modal where the user can set a new size constant.
    
    elem(set_error,modal,w).
    attr(set_error,title,"Error").

    elem(set_error_container, container, set_error).
    attr(set_error_container, flex_direction, "column").
    attr(set_error_container, class, "align-items-end").

    % Add button to apply new size
    elem(set_error_button, button, set_error_container).
    attr(set_error_button, label, "Apply").
    attr(set_error_button, class, "m-1").
    attr(set_error_button, class, "btn-success").


    when(set_error_button, click, call, 
            (
            add_atom(max_error(_context_value(new_max_error))),
            add_atom(min_error(_context_value(new_min_error))))
        ).


    % You get two textfields so the user can set a new number.
    elem(max_error_text, textfield, set_error_container).
    attr(max_error_text, placeholder, "Set max error").
    attr(max_error_text, width, 450).
    when(max_error_text, input, context, (new_max_error, _value)).

    elem(min_error_text, textfield, set_error_container).
    attr(min_error_text, placeholder, "Set min error").
    attr(min_error_text, width, 450).
    when(min_error_text, input, context, (new_min_error, _value)).



