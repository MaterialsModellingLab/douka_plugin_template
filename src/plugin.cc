/*
 * Copyright (c) 2025 Materials Modelling Lab, The University of Tokyo
 * SPDX-License-Identifier: Apache-2.0
 */

#include <douka/plugin_interface.hh>

namespace douka::plugin {
class MyPlugin : public PluginInterface {
public:
  /**
   * @brief Set the option for simulation. This method is called before the predict process.
   *
   * @param opt_file : Option file path given by --plugin_param option
   */
  bool set_option(const std::string &opt_file) override {
    // TODO(User) Read the option file and set the parameters
    (void)opt_file; // Replace this line with your implementation
    return true;
  }

  /**
   * @brief Make a prediction of the next time-step ensemble member.
   *
   * @param s : The vector of state mean value
   * @param n : The noise vector
   */
  bool predict(std::vector<double> &s, [[maybe_unused]] const std::vector<double> &n) override {
    // TODO(User) Implement the prediction process
    (void)s; // Replace this line with your implementation
    return true;
  }
};
}; // namespace douka::plugin

// Register the plugin
#include <douka/plugin_register_macro.hh>
DOUKA_PLUGIN_REGISTER(douka::plugin::MyPlugin)
