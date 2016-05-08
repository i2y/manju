defmodule Mix.Tasks.Compile.Manju do
  use Mix.Task

  @recursive true
  @manifest ".compile.manju"

  def run(_) do
    project = Mix.Project.config
    src_paths = project[:erlc_paths]
    dest_path = Mix.Project.compile_path(project)
    files = Mix.Utils.extract_files(src_paths, "*.mj")
    compile(files)
    renames(files, dest_path)
    # TODO stale
  end

  def compile([file|rest]) do
    Manju.main([file])
    compile(rest)
  end

  def compile([]) do
  end

  def renames([file|rest], dest_path) do
    beam_file = Path.join([Path.dirname(file), Path.basename(file, ".mj")]) <> ".beam"
    rename(beam_file, dest_path)
    renames(rest, dest_path)
  end

  def renames([], dest_path) do
  end

  def rename(file, dest_path) do
    dest_file = Path.join(dest_path, Path.basename(file))
    File.rename(file, dest_file)
  end

  def manifests, do: [manifest]
  defp manifest, do: Path.join(Mix.Project.manifest_path, @manifest)

  def clean do
    Erlang.clean(manifest())
  end
end