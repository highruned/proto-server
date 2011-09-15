spawn = require('child_process').spawn
sys = require('sys')

exec = (command, params) ->
	subprocess = spawn(command, params)
	
	subprocess.stdout.on 'data', (data) ->
	  sys.print(data.asciiSlice(0, data.length))
	
	subprocess.stderr.on 'data', (data) ->
	  sys.print(data.asciiSlice(0, data.length))

exec 'coffee', ['-wco', __dirname + '/lib', __dirname + '/src']
exec 'coffee', ['-wco', __dirname + '/examples', __dirname + '/examples']