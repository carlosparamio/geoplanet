module GeoPlanet
  class Base
    class << self
      def build_url(resource_name, options = {})
        filters       = extract_filters(options)
        matrix_params = extract_matrix_params(options)
        query_params  = extract_query_params(options)

        query_params[:appid] ||= GeoPlanet.appid # use default appid if not provided

        raise ArgumentError if query_params[:appid].nil? || resource_name == 'places' && filters[:q].nil? # required

        q = ".q('#{filters[:q]}')" if filters[:q]
        type = ".type('#{filters[:type].is_a?(Array) ? filters[:type].to_a.join(',') : filters[:type]}')" if filters[:type]
        
        query_string = q && type ? "$and(#{q},#{type})" : "#{q}#{type}"
        
        matrix_params = ";#{matrix_params.map{|k,v| "#{k}=#{v}"}.join(';')}" if matrix_params.any?
        query_params  = "?#{query_params.map{|k,v| "#{k}=#{v}"}.join('&')}"  if query_params.any?
        
        query_string += "#{matrix_params}#{query_params}"
        
        "#{GeoPlanet::API_URL}#{resource_name}#{query_string}"
      end

      protected
      def extract_filters(options)
        filters = %w(q type)
        Hash[*(options.select{|k,v| filters.include?(k.to_s)}).flatten(1)]
      end
      
      def extract_matrix_params(options)
        matrix_params = %w(start count)
        Hash[*(options.select{|k,v| matrix_params.include?(k.to_s)}).flatten]
      end
      
      def extract_query_params(options)
        query_params = %w(lang format callback select appid)
        Hash[*(options.select{|k,v| query_params.include?(k.to_s)}).flatten]
      end
    end
  end
end