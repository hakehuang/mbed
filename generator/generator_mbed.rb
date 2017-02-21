#! ruby -I../

require 'yaml'
require 'yml_merger'

require 'awesome_print'
require 'ebngen'
require 'logger'


@entry_yml = "projects/nxp/frdmk64f.yml"
@search_path  = (Pathname.new(File.dirname(__FILE__)).realpath + 'records/').to_s
merge_unit      = YML_Merger.new(
    @entry_yml, @search_path
)
merged_data     = merge_unit.process()

#myassembly = Assembly.new(merged_data)

translator_unit = Translator.new(
    merged_data, logger: Logger.new(STDOUT)
)
translated_data = translator_unit.translate()

#myassembly.assembly("hello_world")

options = {
  "paths" => {
   "default_path" => Pathname.new(File.dirname(__FILE__)).parent,
   "output_root" => Pathname.new(File.dirname(__FILE__)).parent,
   "mbed_path"  => Pathname.new(File.dirname(__FILE__)).parent,
   "app_path" => Pathname.new(File.dirname(__FILE__)).parent
  },
  "all" => translated_data[0]["hello_world"]
}

translated_data[0]['hello_world']['document'] = {
    "board" => "frdmk64f",
    "project_name" => "hello_world"
}
File.write('./unified_data.yml', YAML.dump(translated_data[0]))
mygenerator = Generator.new(options)
mygenerator.generate_project_set('iar',translated_data[0]['hello_world'])
mygenerator.generate_projects('iar', '', translated_data[0]['hello_world'])

#mygenerator.generate_projects('cmake', '', translated_data[0]['hello_world'])