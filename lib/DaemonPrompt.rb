# Copyright 2010-2013, Raphael Reitzig
# <code@verrech.net>
#
# This file is part of ltx2any.
#
# ltx2any is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# ltx2any is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with ltx2any. If not, see <http://www.gnu.org/licenses/>.

class DaemonPrompt
  def self.run(params)
    command = getCommand
    while ( command.size > 0 )
      begin
        case command[0]
        when :set
          if ( command.size < 3 )
            respond "Please supply a parameter name and a value."
          else
            value = command[2,command.size-1].join(" ")
            params[command[1].to_sym] = value
            respond "Set parameter '#{command[1]}' to '#{value}'."
          end
        when :show
          respond "#{command[0]} = #{params[command[1].to_sym]}"
        when :help
          respond "Work in progress"
        when :clean
          FileUtils::rm_rf(params[:tmpdir])
          if ( command.size > 1 && command[1].to_sym == :all )
            FileUtils::rm("#{params[:log]}.#{params[:logformat].to_s}") # TODO may fail when MD fallback?
            # TODO remove result
          end
        when :run
          break
        when :quit
          raise SystemExit.new("User issued quit command")
        else
          respond "Command #{command[0].to_s} unknown"
        end
      rescue ParameterException => e
        respond "Error: #{e.message}"
      end

      # TODO process commands/options:

      #  open (log|result|source) -- open specified files
      #  show <name> -- shows current value of parameter
      #  set [once] <name> <value> -- sets parameter to value
      #  listen -- commence listening for file changes (?)
      
      command = getCommand
    end

    #  Throw SystemExit for quitting.
    #  Return regularly for rerun.
    # TODO should we allow to return to listening? --> other Exception or return value
  end

  private
    def self.respond(msg)
      puts "\t#{msg}"
      # TODO add line breaking?
    end
  
    def self.getCommand
      print "> "
      command = gets.strip.split(/\s+/) # User may quit by hitting ^C at this point
      if ( command.size > 0 )
        command[0] = command[0].to_sym
      else
        command[0] = :run
      end
      return command
    end
end