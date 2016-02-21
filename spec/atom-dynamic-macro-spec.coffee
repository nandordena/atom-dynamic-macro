helpers = require './spec-helper'

dynamicMacro = require '../lib/atom-dynamic-macro'

describe "Testing Dynamic Macro", ->
  [editor, editorElement] = []

  beforeEach ->
    helpers.getEditorElement (element) ->
      editorElement = element              # DOM要素
      editor = editorElement.getModel()    # エディタ本体      
      editor.setText("")

      # 現在のエディタにおいてCtrl-TでDynamicMacroが呼び出されるようにする
      atom.commands.add 'atom-text-editor', 'atom-dynamic-macro:execute': => dynamicMacro.execute()
      atom.keymaps.add 'test', 'atom-text-editor':
        'ctrl-t': 'unset!'
        'ctrl-t': 'atom-dynamic-macro:execute'
        
  keydown = (key, options={}) ->
    options.element ?= editorElement
    helpers.keydown(key, options)

  it "test repeat function", ->
    expect(dynamicMacro.findRep([1,2,3])).toEqual []
    expect(dynamicMacro.findRep([1,2,3,3])).toEqual [3]
    expect(dynamicMacro.findRep([1,2,3,1,2,3])).toEqual [1,2,3]
    expect(dynamicMacro.findRep([1,2,3,3,1,2,3,3])).toEqual [1,2,3,3]
    
  it "try Dynamic Macro execution", ->
    keydown "a"
    keydown "b"
    keydown "a"
    keydown "b"
    keydown null, ctrl: true  # Ctrl-Tをシミュレートするのに二回のkeydownが必要
    keydown "t", ctrl: true
    #dynamicMacro.execute(test=true)
    expect(editor.getText()).toBe "ababab"
        
