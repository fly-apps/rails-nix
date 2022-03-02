final: super: {
    defaultGemConfig = super.defaultGemConfig // {
      grpc = attrs: (super.defaultGemConfig.grpc attrs) // {
        # Fix newer versions of grpc gem
        postPatch = ''
          substituteInPlace Makefile \
            --replace '-Wno-invalid-source-encoding' ""
          substituteInPlace src/ruby/ext/grpc/extconf.rb \
            --replace "ENV['AR']" "ENV['NONE']"
          substituteInPlace src/ruby/ext/grpc/extconf.rb \
            --replace "ENV['ARFLAGS']" "ENV['NONE']"
        '';
      };

      pg = attrs: (super.defaultGemConfig.pg attrs) // {
        # Strip files that keep `final.postgresql` refs in the closure.
        postInstall = ''
          find $out/lib/ruby/gems/ -name 'pg-*.info' -delete
        '';
      };

      execjs = attrs: (super.defaultGemConfig.execjs attrs) // {
        # Strip files that keep `final.postgresql` refs in the closure.
        propagatedBuildInputs = [];
      };

    };
}
