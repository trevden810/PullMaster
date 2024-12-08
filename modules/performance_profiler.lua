PullMaster.profiler = {
    startTime = 0,
    markers = {}
}

function PullMaster.profiler:Start(name)
    self.markers[name] = debugprofilestop()
end