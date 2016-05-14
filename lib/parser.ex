defmodule Parser do
  @moduledoc false

  def parse(str, module_name) do
    {:ok, tokens, _} = str |> to_char_list |> :lexer.string
    {:ok, list} = tokens
                  |> token_filter(module_name)
                  |> generate_indents([], [0])
                  # |> IO.inspect(limit: 1000)
                  |> :parser.parse
    list
  end

  defp token_filter(tokens, module_name) do
    module_body = Enum.reverse(Enum.reduce(tokens, [], fn(token, acc) ->
      r_token = case token do
        {:name, line, '__name__'} -> {:atom, line, module_name}
        _ -> token
      end

      cond do
        acc == nil ->
          [r_token]
        infix_operator?(token) ->
          [r_token|remove_pre_newlines(acc)]
        newline?(r_token) and comma_or_infix_operator?(last_token(acc)) ->
          acc
        true ->
          [r_token|acc]
      end
    end))
    module_body
  end

  defp generate_indents(tokens, acc, indents_stack) do
    case tokens do
      [] ->
        # IO.inspect Enum.reverse(acc), limit: 1000
        [_|last_dedents] = Enum.map(indents_stack, fn(_) -> {:dedent, 0, []} end)
        Enum.reverse(acc) ++ last_dedents
      _ ->
        [token|rest] = tokens
        cond do
          newline?(token) ->
            #{_, _, token_chars} = token
            #{indent_tokens, new_indents_stack} = _generate_indents(count_spaces(token_chars), indents_stack, [])
            {indent_tokens, new_indents_stack} = _generate_indents(token, indents_stack, [])
            # IO.inspect new_indents_stack
            # IO.inspect indent_tokens
            generate_indents(rest, indent_tokens ++ acc, new_indents_stack)
          true ->
            generate_indents(rest, [token|acc], indents_stack)
        end
    end
  end

  defp _generate_indents(token, indents_stack, acc) do
    # IO.inspect token
    {_, _, token_chars} = token
    counts = count_spaces(token_chars)
    case indents_stack do
      [] ->
        {[{:newline, 0, :newline}|acc], indents_stack}
        #{acc, indents_stack}
      _ ->
        [indent|rest] = indents_stack
        # IO.inspect counts
        cond do
          counts == indent ->
            case acc do
              [{:dedent, _, _}|_] ->
                {acc, indents_stack}
              _ ->
                {[{:newline, 0, :newline}|acc], indents_stack}
            end
          counts > indent ->
            {[{:indent, 0, :indent}|acc], [counts|indents_stack]}
          true ->
            [_|new_indents_stack] = indents_stack
            #_generate_indents(counts,
            _generate_indents(token,
                              new_indents_stack,
                              [{:dedent, 0, :dedent}|acc])
        end
    end
  end

  defp count_spaces(chars) do
    Enum.reduce(chars, 0, fn(char, acc) ->
      case char do
        ?\n -> 0
        ?\s -> acc + 1
        ?\t -> acc + 4
        _ -> acc
      end
    end)
  end

  defp infix_operator?(token) do
    Enum.member?([:op_append, :op_plus, :op_minus, :op_times,
                  :op_div, :op_append, :op_leq, :op_geq,
                  :op_eq, :op_neq, :op_lt, :op_gt,
                  :op_and, :op_or, :op_is, :op_not,
                  :bang, :equals, :pipe, :pipeline,
                  :last_pipeline, :for, :in, :thin_arrow,
                  :fat_arrow, :dot_name_lparen, :dot_name],
                  token_type(token))
  end

  defp comma?(token) do
    token_type(token) == :comma
  end

  defp comma_or_infix_operator?(token) do
    comma?(token) or infix_operator?(token)
  end

  defp newline?(token) do
    token_type(token) == :newline
  end

  defp token_type(nil) do
    nil
  end

  defp token_type(token) do
    elem(token, 0)
  end

  defp last_token(acc) do
    List.first(acc)
  end

  defp remove_pre_newlines(acc) do
    cond do
      newline?(List.first(acc)) ->
        [newline|rest] = acc
        remove_pre_newlines(rest)
      true ->
        acc
    end
  end
end
