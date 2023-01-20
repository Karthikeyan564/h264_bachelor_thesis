from pathlib import Path
import re
import os

output_string_top="""Welcome to Idaten's documentation!
=======================================================================

.. toctree::
   :maxdepth: 2
   :caption: Contents:\n"""
created_files = []

p = Path('../src')
top = [f for f in p.iterdir() if f.is_dir()]
for entries in top:
    os.makedirs('./source/'+entries.name,exist_ok=True)
    output_string = entries.name
    output_string += \
    """\n=======================================================================

.. toctree::
   :maxdepth: 2
   :caption: Contents:\n"""
    output_string_top += '\n   ' + entries.name
    for entry in entries.iterdir():
        if re.search(r".v$",str(entry)):
            filename_in = str(os.path.basename(entry)).split('.')[0]
            with open(entry,'r') as fd_i:
                content = fd_i.read()
                lines = content.split(';')
                for line in lines:
                    match = re.search(r"\bmodule",line)
                    match_desc = re.search(r"\/\*\!(\n|.)*\*\/",line)
                    if match:
                        module_name = line[match.start():].split()[1]
                        output_string+='\n   '+entries.name+'/'+module_name
                        with open('./source/'+entries.name+'/'+module_name+'.rst','w') as fd_o:
                            text = module_name+'\n========================================================\n\n\n';
                            text += """.. symbolator::\n  :alt: {}\n  :align: center\n  :caption: {}\n  :symbolator_cmd: /usr/local/bin/symbolator\n  :name: {}\n\n\n\n""".format(module_name,module_name,module_name)
                            block = line[match.start():].replace('\n',"\n    ")
                            parameters_string = re.search(r"#\([a-zA-Z0-9, =/\n\t_]+\)", block)
                            io_string = re.search(r"[^#)][\n ]*\([a-zA-Z0-9, =/\n\t_\[\]\-\+\:\t\(.\)\"]+\)", block)
                            if parameters_string:
                                span_string = parameters_string.span()
                                text += "  "+block[:span_string[0]]+block[span_string[1]+1:]+'\n'
                                text += '  endmodule'
                                string_list = parameters_string.group(0).split('\n')
                                text += "\n\nParameters\n-------------------------------\n\n\n"
                                for i in string_list:
                                    has_doc=re.search(r'//',i)
                                    has_parameter=re.search('parameter *[a-zA-Z0-9_]*',i)
                                    if has_parameter:
                                        text+="* **"+has_parameter.group(0).split()[1]+"**"
                                    if has_doc:
                                        text+="\n   "+str("".join(i[has_doc.end()+1:]))+" \n"
                                    if(not has_doc):
                                        text+="\n";
                            else:
                                text += "  "+block+'\n'
                                text += '  endmodule'
                            if io_string:
                                string_list = io_string.group(0).split('\n')
                                input_text="\n\nInputs\n-------------------------------\n\n\n"
                                output_text="\n\nOutputs\n-------------------------------\n\n\n"
                                flag_in=0;
                                flag_out=0;
                                for i in string_list:
                                    has_doc=re.search(r'//',i)
                                    has_input=re.search('input[a-zA-Z0-9 =/,_\[\]\-\+\: \t\(.\)\"]*',i)
                                    has_output=re.search('output[a-zA-Z0-9 =/,_\[\]\-\+\: \t\(.\)\"]*',i)
                                    if has_input:
                                        flag_in=1;
                                        input_text+="* **"+" ".join(has_input.group(0).split(',')[0].split()[1:])+"**"
                                        if has_doc:
                                            input_text+="\n   "+str("".join(i[has_doc.end()+1:]))+" \n"
                                        if(not has_doc):
                                            input_text+="\n";
                                    if has_output:
                                        flag_out=1;
                                        output_text+="* **"+" ".join(has_output.group(0).split("//")[0].split()[1:])+"**"
                                        if has_doc:
                                                output_text+="\n   "+str("".join(i[has_doc.end()+1:]))+" \n"
                                        if(not has_doc):
                                            output_text+="\n";
                                if flag_in:
                                    text += input_text
                                if flag_out:
                                    text += output_text
                            if match_desc:
                                text+="\n\nDescription\n-------------------------------\n\n"
                                text+=match_desc.group(0)[3:-2]
                            fd_o.write(text)
                        created_files+=[module_name]
    with open("source/"+str(entries.name)+".rst",'w') as ft:
        ft.write(output_string)
        
        

with open('source/index.rst','w') as fd_o:
    fd_o.write(output_string_top)
