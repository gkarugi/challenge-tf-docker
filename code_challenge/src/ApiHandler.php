<?php

namespace Src;

class ApiHandler {
    public static function getServerStats() {
        
        $load = "";
        $disk = "";

        $freespace = disk_free_space("/");
        $disk = round($freespace / 1024 / 1024 / 1024 ,0) . ' GB';

        if (stristr(PHP_OS, "win")) {
            $cmd = "wmic cpu get loadpercentage /all";
            @exec($cmd, $output);

            if ($output)
            {
                foreach ($output as $line)
                {
                    if ($line && preg_match("/^[0-9]+\$/", $line))
                    {
                        $load = $line;
                        break;
                    }
                }
            }
        } else {
            // TODO: test on other OSs
            $sysload = sys_getloadavg();
            $load = $load[0];
        }

        return [
            "avgLoad" => $load,
            "available_disk_space" => $disk
        ];
    }
}