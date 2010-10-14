use ExtUtils::MakeMaker;

my $file = "plugins/PluginDirectory/config.yaml";
my $version = LoadFile($file)->{version} ||
    die "No version found in $file";

WriteMakefile(
    NAME            => 'PluginDirectory',
    VERSION         => $version,
    DISTNAME        => 'PluginDirectory',
);
