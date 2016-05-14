# Manju
Manju is a simple object oriented, dynamically typed, functional language that runs on the [Erlang](http://www.erlang.org) virtual machine (BEAM).
Manju's syntax is [Python](https://www.python.org)-like syntax.
Manju also got an influence from [Ruby](https://www.ruby-lang.org) and [Mochi](https://github.com/i2y/mochi).

Its interpreter is written in [Elixir](http://elixir-lang.org). The interpreter translates a program written in Manju to Erlang's AST / bytecode.

## Language features
### Class definition
Car.mj
```python
class Car:
    def __new__():
        {'name': "foo",
         'speed': 100}
    
    def format(self):
        # self's state is immutable and private.
        # self's state can be referred by "self.attr_name" form.
        self.name.display()
        self.speed.display()

# # usage:
# car = new Car()
# car.format()
```

### Module definition
Enumerable.mj
```python
def select(self, func):
    _select = lambda item, acc:
        if func.(item):
            acc.append(item)
        else:
            acc

    self.reduce([], _select)


def map(self, func):
    _map = lambda item, acc:
        acc.append(func.(item))
    
    self.reduce([], _map)
```

### Mixing in Modules
SampleList.mj
```python
class SampleList:
    include Enumerable

    def __new__(items):
        {'items': items}
    
    def reduce(self, acc, func):
        lists::foldl(func, acc, self.items)

# # usage:
# sample_list = new SampleList([1, 2, 3])
# sample_list.select(lambda item: item > 1)
#            .map(lambda item: item * 2}
#            # => [4, 6]
```

### Pipe operator
```python
[1, 2, 3] |> lists::append([4, 5, 6])
          |> lists::append([7, 8, 9])
# => [1, 2, 3, 4, 5, 6, 7, 8, 9]

[1, 2, 3] |>> lists::append([4, 5, 6])
          |>> lists::append([7, 8, 9])
# => [7, 8, 9, 4, 5, 6, 1, 2, 3]
```

### Other supported features
- Tail recursion optimization
- Pattern matching
- List comprehension

### Not supported features
- Class inheritance
- Lisp-like Macro definition

## Installation
```sh
$ git clone https://github.com/i2y/manju.git
$ cd manju
$ mix archive.build
$ mix archive.install
```

## Usage
mix.exs file example:
```elixir
defmodule MyApp.Mixfile do
  use Mix.Project

  def project do
    [app: :my_app,
     version: "1.0.0",
     compilers: [:manju|Mix.compilers],
     deps: [{:manju, git: "https://github.com/i2y/manju.git"}]]
  end
end
```
".mj" files in source directory(src) is automatically compiled by Mix command.
