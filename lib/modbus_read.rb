#require './lib/modbus-cli'
require 'rmodbus/errors'
require 'rmodbus/ext'
require 'rmodbus/debug'
require 'rmodbus/options'
require 'rmodbus/rtu'
require 'rmodbus/tcp'
require 'rmodbus/slave'
require 'rmodbus/client'
require 'rmodbus/server'
require 'rmodbus/tcp_slave'
require 'rmodbus/tcp_client'
require 'rmodbus/tcp_server'
require 'yaml'

class Read

  MAX_READ_COIL_COUNT = 1000
  MAX_READ_WORD_COUNT = 100
  
  attr_reader :ip, :array_variable

  def initialize equipment
    @ip    = equipment.ip
    @host  = equipment.ip
    @port  = 502
    @count = 1
    @slave = 1

    @array_variable = equipment.variable
  end

  def run
    result = []
    prs_array = []
    @array_variable.each do |var|
      prs = Thread.new do
        cmd = Modbus::Cli::CommandLineRunner.new('modbus-cli') 
        res = cmd.run(["read", %W(#{@ip} %MW#{var.address} 1)])
        value = res[var.address].to_f
        var.table_value.create(value:value, datetime:Time.now)
        result << res
      end
      prs.join
    end
  end

  def read_floats(sl, value)
    floats = read_and_unpack(sl, 'g')
    result = {}
    (0...@count).each do |n|
      result[address_to_s(value.address.to_i + n * value.data_size, value)] = floats[n]
      #puts "#{ '%-10s' % address_to_s(addr_offset + n * data_size)} #{nice_float('% 16.8f' % floats[n])}"
    end
  end

  def read_dwords(sl, value)
    dwords = read_and_unpack(sl, 'N')
    (0...@count).each do |n|
      #puts "#{ '%-10s' % address_to_s(value.address + n * value.data_size, value)} #{'%10d' % dwords[n]}"
    end
  end

  def read_registers(sl,value,  options = {})
    data = read_data_words(sl, value)
    if options[:int]
      data = data.pack('S').unpack('s')
    end
    result = {}
    value.read_range.zip(data).each do |pair|
      result[address_to_s(pair.first, value)] = pair.last
      #puts "#{ '%-10s' % address_to_s(pair.first)} #{'%6d' % pair.last}"
    end
    return result
  end

  def read_words_to_file(sl, value)
    write_data_to_file(read_data_words(sl, value))
  end

  def read_coils_to_file(s, valuel)
    write_data_to_file(read_data_coils(sl, value))
  end

  def write_data_to_file(data, value)
    File.open(output, 'w') do |file|
      file.puts({ :host => @host, :port =>@port, :slave => @slave, :offset => address_to_s(addr_offset, value, :modicon), :data => data }.to_yaml)
    end
  end

  def read_coils(sl, value)
    data = read_data_coils(sl)
    value.read_range.zip(data) do |pair|
      #puts "#{ '%-10s' % address_to_s(pair.first, value)} #{'%d' % pair.last}"
    end
  end

  def execute_range
    #find min and max address
    min, max = 10000, 0
    @array_variable.each do |var|
      if var.address.to_i >= max
        max = var.address.to_i
      end
      if var.address.to_i <= min
        min = var.address.to_i
      end
    end
    rezult = {}
    rezult_read = []
    ModBus::TCPClient.connect(@host, @port) do |cl|
      cl.with_slave(1) do |slave|
        slave.debug = false
        regs = slave.holding_registers
        data =  regs[min..max]
        data.each do |ea|
          rezult_read << ea
        end
        #p slave.read_holding_registers(100, 100)
      end
    end
    @array_variable.each do |var|
      var.table_value.create(value:rezult_read[(var.address.to_i - min)], datetime:Time.now)
      rezult[var.address] =  rezult_read[(var.address.to_i - min)]
    end
    rezult
  end

  def execute
    result = []
    slave  = 1
    ModBus::TCPClient.connect(@host, @port) do |cl|
      cl.with_slave(slave) do |sl|
        @array_variable.each do |var|
          sl.debug = false#true
          regs = sl.holding_registers

          case var.var_type 
          when 'boolean'
            value = read_coils(sl, var)
          when 'int'
            value =  read_registers(sl, var, :int => true)
          when 'word'
            value =  read_registers(sl, var)
          when 'float'
            value =  read_floats(sl, var)
          when 'dword'
            value = read_dwords(sl, var)
          end
          if result.length%20 == 0
            slave += 1
          end
          #var.table_value.create(value:value[value.keys[0]], datetime:Time.now)
          result << value 
        end
      end
    end
    return result
  end

  def read_and_unpack(sl, format)
    # the word ordering is wrong. calling reverse two times effectively swaps every pair
    read_data_words(sl).reverse.pack('n*').unpack("#{format}*").reverse
  end

  def read_data_words(sl, value)
    result = []
    value.read_range.each_slice(MAX_READ_WORD_COUNT) {|slice| result += sl.read_holding_registers(slice.first, slice.count) }
    result
  end


  def read_data_coils(sl, value)
    result = []
    value.read_range.each_slice(MAX_READ_COIL_COUNT) do |slice|
      result += sl.read_coils(slice.first, slice.count)
    end
    result
  end

  def data_size
    case addr_type
    when :bit, :word, :int
      1
    when :float, :dword
      2
    end
  end

  def addr_offset
    address[:offset]
  end

  def read_range
    (addr_offset..(addr_offset + @count * data_size - 1))
  end


  def nice_float(str)
    m = str.match /^(.*[.][0-9])0*$/
    if m
      m[1]
    else
      str
    end
  end

  def address_to_s(addr, value,  format = :schneider )
    case format
    when :schneider
      case value.var_type
      when 'boolean'
        '%M' + addr.to_s
      when 'word', 'int'
        '%MW' + addr.to_s
      when 'dword'
        '%MD' + addr.to_s
      when 'float'
        '%MF' + addr.to_s
      end
    when :modicon
      case value.var_type
      when 'boolean'
        (addr + 1).to_s
      when 'word', 'int'
        (addr + 400001).to_s
      end
    end
  end

end
