module PortfolioHelper
    def is_a_param(key, value)
        if params.include?(key)
            current = params[key]
            if current.is_a?(Array)
                if current.include?(value)
                    return true
                else
                    return false
                end
            else
                if current == value
                    return true
                else
                    return false
                end 
            end
        else
            return false
        end
    end

    def portfolio_params
        params.permit(:sort, :filter_in, :filter_out, :tab)
    end

    def hash_path(hash, remove = false)
        current_params = portfolio_params.merge(request.query_parameters)
        #final_params = remove ? remove_parts(current_params, hash) : combine_or_remove_dup(current_params, hash)
        final_params = new_combine(current_params, hash)
        portfolio_path(final_params)
    end

    private
    def new_combine(hash1, hash2)
        combined_hash = hash1.dup
        hash2.each do |key, value|
            puts value
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
