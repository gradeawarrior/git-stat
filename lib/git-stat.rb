class Git

  UNKNOWN_TYPE = 'UNKNOWN_TYPE'

  def self.project_name
    `printf '%s\n' "${PWD##*/}"`.chomp
  end

  def self.ls_files
    `git ls-files`.split(/\n/)
  end

  def self.remote_branches
    `git branch -a | grep remotes | awk '{print $1}'`.split(/\n/)
  end

  def self.tags
    `git tag -l`.split(/\n/)
  end

  def self.blame(file)
    `git blame "#{file}"`
  end

  def self.line_count(file)
    `git blame "#{file}" | wc -l`.to_i
  end

  def self.file_stat(file)
    authors = {}
    line_count = 0
    type = File.extname(file).empty? ? UNKNOWN_TYPE : File.extname(file)
    begin
      lines = blame(file).split(/\n/)
      line_count = lines.length
      lines.each do |line|
        if (line.match(/\((.*?)\s+[0-9]{4}-[0-9]{2}-[0-9]{2}\s+[0-9]{2}:[0-9]{2}:[0-9]{2}\s.[0-9]*\s+[0-9]*\)/))
          authors[$1] += 1 if authors.has_key?($1)
          authors[$1] = 1 unless authors.has_key?($1)
        else
          $stderr.puts "[WARN] Did not find whom to blame on this line in file: #{file}"
          $stderr.flush
        end
      end
    rescue Exception
      line_count = Git::line_count(file)
    end
    {
      :file => file,
      :type => type,
      :line_count => line_count,
      :authors_influence => authors
    }
  end

  def self.merge_hash_value_counts(h1, h2)
    h2.each_key.inject(h1) do |result,key|
      result[key] += h2[key] if result.has_key?(key)
      result[key] = h2[key] unless result.has_key?(key)
      result
    end
  end

  def self.sort_hash(hash)
    sorted_array = hash.sort_by {|k,v| v}.reverse
    sorted_array.inject({}) do |result,element|
      result[element[0]] = element[1]
      result
    end
  end

  def self.files_stat
    files = Git::ls_files()
    number_of_files = files.length
    types_count = {}
    line_counts = {}
    line_counts_by_type = {}
    authors_influence = {}
    total_line_counts = 0

    file_index = 0
    files.each do |file|
      file_index += 1
      file_stat = file_stat(file)
      authors_influence = merge_hash_value_counts(authors_influence, file_stat[:authors_influence])
      total_line_counts += file_stat[:line_count]

      if types_count.has_key?(file_stat[:type])
        types_count[file_stat[:type]] += 1
        line_counts_by_type[file_stat[:type]] += file_stat[:line_count]
      else
        types_count[file_stat[:type]] = 1
        line_counts_by_type[file_stat[:type]] = file_stat[:line_count]
      end
      line_counts[file] = Git::line_count(file)
    end

    {
      :number_of_files => number_of_files,
      :total_line_counts => total_line_counts,
      :file_types => sort_hash(types_count),
      :line_counts_by_type => sort_hash(line_counts_by_type),
      :authors_influence => sort_hash(authors_influence)
    }
  end

  def self.all_stats
    stats = files_stat()
    {
      'project_name' => Git::project_name(),
      'total_files' => stats[:number_of_files],
      'total_lines' => stats[:total_line_counts],
      'file_types' => stats[:file_types],
      'authors_line_count' => stats[:authors_influence],
      'line_counts_by_type' => stats[:line_counts_by_type],
      'branches' => Git::remote_branches(),
      'tags' => Git::tags()
    }
  end

end