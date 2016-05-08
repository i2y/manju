# Manju

Manju is a simple OOP, dynamically typed, functional language that runs on the [Erlang](http://www.erlang.org) virtual machine (BEAM).
Manju's syntax is [Python](https://www.python.org)-like syntax.
Manju also got an influence from [Ruby](https://www.ruby-lang.org) and [Mochi](https://github.com/i2y/mochi).

Its interpreter is written in [Elixir](http://elixir-lang.org). The interpreter translates a program written in Manju to Erlang's AST / bytecode.

## Language features
### Class definition
Car.mj
```python
class Car:
    def __new__():
        {:name : "foo",
         :speed : 100}
    
    def inspect(self):
        "Elixir.IO"::inspect(self.name)
        "Elixir.IO"::inspect(self.speed)

# car = new Car()
# car.inspect()
```

### Module definition
Enumerable.mj
```python
def select(self, func):
    _select = lambda item, acc:
        if func.(item):
            acc ++ [item]
        else:
            acc

    self.reduce([], _select)

def filter(self, func):
    _filter = lambda item, acc:
        if func.(item):
            acc ++ [item]
        else:
            acc
    
    self.reduce([], _filter)

def reject(self, func):
    _reject = lambda item, acc:
        if func.(item):
            acc
        else:
            acc ++ [item]
    
    self.reduce([], _reject)

def map(self, func):
    _map = lambda item, acc:
        acc ++ [func.(item)]
    
    self.reduce([], _map)

def collect(self, func):
    _collect = lambda item, acc:
        acc ++ [func.(item)]

    self.reduce([], _collect)

def min(self, func):
    _min = lambda item, acc:
        match func.(acc, item):
            case -1:
                0
            case 0:
                0
            case 1:
                item
    
    self.reduce(:infinity, _min)

def min(self):
    _min = lambda item, acc:
        if acc <= item:
            acc
        else:
            item
    
    self.reduce(:infinity, _min)

def unique(self):
    _unique = lambda item, acc:
        if acc.index_of(item):
            acc
        else:
            acc ++ [item]
    
    self.reduce([], _unique)

def each(self, func):
    _each = lambda item, acc:
        func.(item)
    
    self.reduce([], _each)
```

### Mixing in Modules
SampleList.mj
```python
class SampleList:
    include Enumerable
  
    def __new__(items):
        {items: items}
    
    def reduce(self, acc, func):
        lists::foldl(func, acc, self.items)

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
- Macro definition

## Installation
TODO

## Usage
Mixfile example 
```elixir
defmodule Manju.Mixfile do
  use Mix.Project

  def project do
    [app: :manju,
     version: "0.0.1",
     elixir: "~> 1.1",
     compilers: [:manju] ++ Mix.compilers,
     escript: [main_module: Manju],
     docs: [readme: true, main: "README.md"]]
  end
end
```
".mj" files in source directory(src) is automatically compiled by mix command.
