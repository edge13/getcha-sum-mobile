fs     = require 'fs'
{exec} = require 'child_process'
util   = require 'util'
os =  require('os')

#configuration
output_dir = 'Resources/js'
bundle_dir = 'Resources/bundles'
excluded_js_sources = [
    'app.js',
    'static_server.js'
]
require_proof_dirs = ["libs"]
output_filters = ['[DEBUG]', '[TRACE]']

pwd = "`pwd`"
titanium_root = "$HOME/Library/Application\\ Support/Titanium"
sdk_version = '2.1.3.GA'
slash = "/"
rm = "rm"
mkdir = "mkdir -p"
remove_folder = "rm -rf"
copy_folder = "cp -r"
search = "find"
adb = "$ANDROID_HOME/platform-tools/adb"
and_command = ";"
zip = "zip -r"
new_line = "\n"
ls = "ls"

app_id = 'com.si.progo'
app_name = 'Progo'
ios_sdk = "6.0"
iphone_device = 'iphone'

titanium = titanium_root + '/mobilesdk/osx/' + sdk_version + '/'

fileRegex = new RegExp "require\\(\"(.*?)\"\\)", ["g"]
sourceRegex = new RegExp "\"(.*?)\""

convertVariablesToWindows = (callback)->
  if os.platform() is "win32"
    pwd = "%CD%"
    titanium_root = pwd + "/sdk"
    titanium = 'sdk/mobilesdk/win32/' + sdk_version + '/'
    slash = "\\"
    rm = "del"
    mkdir = "md"
    remove_folder = "rd /Q /S"
    copy_folder = "xcopy /E/H/Y"
    search = "dir /b/s"
    adb = "adb"
    and_command = "&"
    zip = "7z a -r"
    output_dir = 'Resources\\js'
    bundle_dir = 'Resources\\bundles'
    new_line = "\r\n"
    ls = "dir /B"
  do callback


option '-c', '--clean', 'clean the generated javascript source'
option '', '--name [NAME]', 'name for new widget'
            
task 'iphone', 'Build for iphone', (options) ->
  if options.clean
    cleanupJS ->
      console.log "generating js"
      generateJS "`pwd`/src", true, ->
        console.log "processing js requires"
        processJSRequires ->
          console.log "building sim"
          do buildIphoneSimulator
  else
    generateJS "`pwd`/src", true, ->
      processJSRequires ->
        do buildIphoneSimulator

task 'android', 'Build for android', (options) ->
  convertVariablesToWindows ->
    if options.clean    
      cleanupJS ->
        clearLogCat ->
          generateJS "#{pwd}#{slash}src", true, ->
            processJSRequires ->
                do buildAndroidDevice 
    else
      generateJS "#{pwd}#{slash}src", true, ->
        processJSRequires ->
           do buildAndroidDevice

task 'clean', 'Delete generated JS sources', ->
  convertVariablesToWindows ->
    console.log "[INFO] Cleaning build directory"
    exec remove_folder + " build", (err, stdout, stderr) ->
      throw err if err    
      cleanupJS ->

task 'generateJS', 'Generate JS source from Coffeescript Source', ->
    do generateJS

doStaticServerConfig = (callback)-> 
  exec "#{rm} Resources#{slash}static_server_config.json", (err, stdout, stderr) ->
    if os.platform() is "win32"
      exec 'ping %computername% -4 -n 1 ^ | find /i "reply"', (err, stdout, stderr) ->
        ipaddr = stdout.replace(/.*?(\d+\.\d+\.\d+\.\d+).*/, (start, found) -> return found)
        ipaddr = ipaddr.replace("\n", "")
        exec "echo {\"hostname\":\"#{ipaddr}\"} > Resources/config/static_server_config.json", (err, stdout, stderr) ->
          do callback
    else
      exec "ifconfig | grep \"inet \" | grep -v 127.0.0.1 | cut -d\\  -f2", (err, stdout, stderr) ->
        ipaddr = stdout.split('\n')[0]
        exec "echo \"{\\\"hostname\\\":\\\"#{ipaddr}\\\"}\" > Resources/config/static_server_config.json", (err, stdout, stderr) ->
          do callback

processJSRequires = (callback) ->
  func = (file, callback) ->
    fs.readFile file, 'utf8', (err, data) ->
      throw err if err
      requires = data.match fileRegex
      if requires?
        for _require in requires
          if shouldReplaceRequire(_require)
            sourceFile = sourceRegex.exec _require
            newRequire = _require.replace sourceFile[1], "js/#{sourceFile[1]}" 
            data = data.replace _require, newRequire
        fs.writeFile file, data, (err) ->
          throw err if err
          do callback
      else
        do callback
  command = "find #{output_dir} -name \"*.js\""
  if os.platform() is 'win32'
    command = "dir #{output_dir}\\*.js /b/s"
  exec command, (err, stdout, stderr) ->
    files = stdout.split("#{new_line}")
    do files.pop
    recursiveExecute func, files, 0, ->
      do callback

shouldReplaceRequire = (_require) ->
  for directory in require_proof_dirs
    return false if _require.indexOf(directory) isnt -1
  true

recursiveExecute = (func, args, index, completion) ->
  func args[index], ->
    if index is args.length - 1
      do completion
    else
      recursiveExecute func, args, index + 1, completion

buildIphoneSimulator = ->
  console.log '[INFO] Building for iPhone Simulator'
  ti_build = titanium + 'iphone/builder.py'
  child = exec "bash -c \"#{ti_build} run `pwd` #{ios_sdk} #{app_id} #{iphone_device}\"", (err, stdout, stderr) ->
  child.stdout.on 'data', (data)->
    filterLogs data

buildAndroidDevice = ->
  console.log '[INFO] Building for Android Device'
  ti_build = titanium + "android/builder.py"
  if os.platform() is 'win32'
    ti_build = "builder.py"
    console.log "[INFO] Installing on device. . . "
    exec "#{ti_build} install #{app_name} %ANDROID_HOME% %CD% #{app_id} 18", (err, stdout, stderr) ->   
      throw err if err    
      console.log "[INFO] App installed!"
  else
    child = exec "bash -c \"#{ti_build} install #{app_name} $ANDROID_HOME `pwd` #{app_id} test\"", (err, stdout, stderr) ->
      throw err if err
      do launchAndroid
      child.stdout.on 'data', (data) ->
        filterLogs data

launchAndroid = ->
  console.log '[INFO] Launching on device...'
  exec "$ANDROID_HOME/platform-tools/adb shell am start -n #{app_id}/#{app_id}.#{app_name}Activity", (err, stdout, stderr) ->
    throw err if err
    do startLogCat

startLogCat = ->
  console.log '[INFO] Starting logcat'
  logcat = exec "#{adb} logcat TiAPI:V *:S -v tag", (err, stdout, stderr) ->
  logcat.stdout.on 'data', (data) ->
    logs = data.split('\n')
    for log in logs when log isnt ''
      console.log log

filterLogs = (data) ->
  logs = data.split('\n')
  for log in logs when log isnt ''
    if shouldShowLogStatement log
      console.log log

shouldShowLogStatement = (data) ->
  for filter in output_filters
    return false if data.indexOf(filter) >= 0
  true

cleanupJS = (callback) ->
  console.log '[INFO] Cleaning up old JS sources'
  exec "#{remove_folder} #{bundle_dir}", (err, stdout, stderr) ->
    exec "#{rm} Resources#{slash}static_server_config.json", (err, stdout, sterr) ->
      exec "#{remove_folder} #{output_dir}", (err, stdout, stderr) ->
        do callback
clearLogCat = (callback) ->
  console.log '[INFO] Cleaning logcat'
  exec "#{adb} logcat -c", (err, stdout, stderr) ->
    throw err if err
    do callback

generateJS = (source, output, callback) ->
  console.log '[INFO] Compiling coffeescript sources'
  command = "find #{source} -name \"*.coffee\""
  if os.platform() is 'win32'
    command = "dir #{source}\\*.coffee /b /s"
  exec command, (err, stdout, stderr) ->
    throw err if err
    generateJSFiles stdout, output, callback

generateJSFiles = (stdout, output, callback)->
  files = stdout.split("\n")
  sources = ''
  first = true
  for file in files when file isnt ''
    file = file.replace /[ ]/, "\\ "
    sources += ' ' + file if not first
    sources += file if first
    first = not first if first
  if output
    exec "coffee -o #{output_dir} -c -b #{sources}", (err, stdout, stderr) ->
      console.log "[INFO] Javascript generated to #{output_dir}/"
      throw err if err
      do callback
  else
    exec "coffee -c -b #{sources}", (err, stdout, stderr) ->
      console.log "[INFO] Javascript generated to #{output_dir}/"
      console.log stdout
      console.log stderr
      throw err if err
      do callback



