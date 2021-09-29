local RunService = game:GetService("RunService")

local ScriptBinding = {}
ScriptBinding.__index = ScriptBinding

local BindingId: number = 0

function ScriptBinding:IsBinded()
	return self._binded == true
end

function ScriptBinding:Unbind()
	if self._binded == false then
		return
	end

	self._binded = false
	RunService:UnbindFromRenderStep(
		self._bindingId
	)
end

export type ScriptBinding = typeof(
	setmetatable({}, ScriptBinding)
)

-- Binds a function to a certain priority in RenderStep
return function(
	priority: number,
	callback: (deltaTime: number) -> ()
): ScriptBinding
	assert(
		typeof(priority) == 'number',
		"Must be number"
	)

	assert(
		typeof(callback) == 'function',
		"Must be function"
	)

	BindingId += 1
	local bindingId = (
		"BindToRenderStep_".. BindingId
	)

	RunService:BindToRenderStep(
		bindingId,
		priority,
		callback
	)

	return setmetatable({
		_binded = true,
		_bindingId = bindingId
	}, ScriptBinding)
end
