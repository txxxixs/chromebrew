require 'package'

class Ruby_mdl < Package
  description 'Style checker/lint tool for markdown files.'
  homepage 'https://github.com/markdownlint/markdownlint'
  version '0.12.0'
  compatibility 'all'
  source_url 'SKIP'

  no_fhs
  no_compile_needed

  depends_on 'libyaml'
  depends_on 'ruby'

  def self.install
    FileUtils.mkdir_p CREW_DEST_PREFIX
  end

  def self.postinstall
    @gem_name = name.sub('ruby_', '')
    system "gem uninstall -Dx --force --abort-on-dependent #{@gem_name}", exception: false
    system "gem install -N #{@gem_name}", exception: false
  end

  def self.remove
    @gem_name = name.sub('ruby_', '')
    @gems_deps = `gem dependency ^#{@gem_name}\$ | awk '{print \$1}'`.chomp
    # Delete the first line and convert to an array.
    @gems = @gems_deps.split("\n").drop(1).append(@gem_name)
    # bundler never gets uninstalled, though gem dependency lists it for
    # every package, so delete it from the list.
    @gems.delete('bundler')
    @gems.each do |gem|
      system "gem uninstall -Dx --force --abort-on-dependent #{gem}", exception: false
    end
  end
end
