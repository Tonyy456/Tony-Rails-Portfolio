module PortfolioHelper
    def is_a_param(key, value)
        if params.include?(key)
            current = params[key]
            if (current.is_a?(Array) && current.include?(value)) || current == value
                return true
            end
        end
        false
    end

    def get_class(num)
        num > 0 ? "danger" : "secondary"
    end

    def portfolio_params
        params.permit(:sort, :filter_in, :filter_out, :tab, :completed, :currently_on)
    end

    def hash_path(hash, remove = false)
        current_params = portfolio_params.merge(request.query_parameters)
        final_params = remove ? combine_keep_one(current_params, hash) : combine(current_params, hash)
        portfolio_path(final_params)
    end

    private
    def combine_keep_one(hash1, hash2)
        combined_hash = hash1.dup
        hash2.each do |key, value|
            if combined_hash.key?(key) # extend to array
                existing_value = combined_hash[key]
                if existing_value == value
                    combined_hash.delete(key)
                else
                    combined_hash[key] = value
                end
            else
                combined_hash[key] = value
            end
        end
        combined_hash
    end
    
    def combine(hash1, hash2)
        combined_hash = hash1.dup
        hash2.each do |key, value|
            if combined_hash.key?(key) # extend to array
                existing_value = combined_hash[key]
                if existing_value.is_a?(Array)
                    if existing_value.include?(value)
                        combined_hash[key].delete(value)
                        if combined_hash[key].count == 1
                            combined_hash[key] = combined_hash[key][0]
                        end
                    else
                        combined_hash[key] = existing_value << value
                    end
                else
                    if existing_value == value
                        combined_hash.delete(key)
                    else
                        combined_hash[key] = [existing_value, value]
                    end
                end
            else # add item alone
                combined_hash[key] = value
            end
        end
        combined_hash
    end
end
