{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.hardware.fancontrol;
  configFile = pkgs.writeText "fancontrol.conf" cfg.config;

in{
  options.hardware.fancontrol = {
    enable = mkEnableOption "software fan control (requires fancontrol.config)";

    config = mkOption {
      default = null;
      type = types.nullOr types.lines;
      description = "Fancontrol configuration file content. See <citerefentry><refentrytitle>pwmconfig</refentrytitle><manvolnum>8</manvolnum></citerefentry> from the lm_sensors package.";
      example = ''
        # Configuration file generated by pwmconfig
        INTERVAL=10
        DEVPATH=hwmon3=devices/virtual/thermal/thermal_zone2 hwmon4=devices/platform/f71882fg.656
        DEVNAME=hwmon3=soc_dts1 hwmon4=f71869a
        FCTEMPS=hwmon4/device/pwm1=hwmon3/temp1_input
        FCFANS= hwmon4/device/pwm1=hwmon4/device/fan1_input
        MINTEMP=hwmon4/device/pwm1=35
        MAXTEMP=hwmon4/device/pwm1=65
        MINSTART=hwmon4/device/pwm1=150
        MINSTOP=hwmon4/device/pwm1=0
      '';
    };
  };

  config = mkIf cfg.enable {
    systemd.services.fancontrol = {
      unitConfig.Documentation = "man:fancontrol(8)";
      description = "software fan control";
      wantedBy = [ "multi-user.target" ];
      after = [ "lm_sensors.service" ];

      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.lm_sensors}/sbin/fancontrol ${configFile}";
      };
    };
  };
}
