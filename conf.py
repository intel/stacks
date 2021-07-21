# Configuration file for the Sphinx documentation builder.
#
# This file only contains a selection of the most common options. For a full
# list see the documentation:
# https://www.sphinx-doc.org/en/master/usage/configuration.html

# -- Path setup --------------------------------------------------------------

# If extensions (or modules to document with autodoc) are in another directory,
# add these directories to sys.path here. If the directory is relative to the
# documentation root, use os.path.abspath to make it absolute, like shown here.
#
# import os
# import sys
# sys.path.insert(0, os.path.abspath('.'))
from docutils import nodes



# -- Project information -----------------------------------------------------

project = u'System Stacks for Linux* OS'
copyright = u'2020'
author = u'many'


# -- General configuration ---------------------------------------------------

# Add any Sphinx extension module names here, as strings. They can be
# extensions coming with Sphinx (named 'sphinx.ext.*') or your custom
# ones.
extensions = ["recommonmark", "sphinx_markdown_tables", "sphinx_tabs.tabs"]
source_suffix = {'.rst': 'restructuredtext', '.md': 'markdown'}

# Add any paths that contain templates here, relative to this directory.
templates_path = ['_templates']

# List of patterns, relative to source directory, that match files and
# directories to ignore when looking for source files.
# This pattern also affects html_static_path and html_extra_path.
exclude_patterns = ['_build', 'Thumbs.db', '.DS_Store']

# These folders are copied to the documentation's HTML output
html_static_path = ['_static']

# These paths are either relative to html_static_path
# or fully qualified paths (eg. https://...)
html_css_files = [
    'css/custom.css',
]

# -- Options for HTML output -------------------------------------------------

# The theme to use for HTML and HTML Help pages.  See the documentation for
# a list of builtin themes.
#
html_theme = 'sphinx_rtd_theme'
html_logo = '_figures/stacks_logo.png'
html_short_name = 'Home'


# Add any paths that contain custom static files (such as style sheets) here,
# relative to this directory. They are copied after the builtin static files,
# so a file named "default.css" will overwrite the builtin "default.css".
# html_static_path = ['_static']

html_theme_options = {
    'display_version': False,
    'collapse_navigation': False,
    'style_external_links': True

}



#github_url = "https://github.com/intel/stacks/"


#html_context = {
#    "display_github": True, # Integrate GitHub
#    "github_user": "intel", # User name
#    "github_repo": "stacks", # Repo name
#    "github_version": "master", #Branch name
#}



#def setup(app):
#    app.connect('doctree-resolved',fixLocalMDAnchors)

def fixLocalMDAnchors(app, doctree, docname):
    for node in doctree.traverse(nodes.reference):
        uri = node.get('refuri')
        print("the URI in question is ", uri)
        if '.md#' in uri and 'https:// <https://> ' not in uri:
            print(uri)
            node['refuri'] = node['refuri'].replace('.md#','.html#')
