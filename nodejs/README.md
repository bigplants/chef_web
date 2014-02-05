nodejs Cookbook
===============

This cookbook is install nodejs.

Attributes
----------

#### nodejs::default
<table>
  <tr>
    <th>Key</th>
    <th>Type</th>
    <th>Default</th>
  </tr>
  <tr>
    <td><tt>['nodejs']['version']</tt></td>
    <td>String</td>
    <td><tt>v0.10.18</tt></td>
  </tr>
  <tr>
    <td><tt>['nodejs']['nvm_install_dir']</tt></td>
    <td>String</td>
    <td><tt>/usr/local/nvm/</tt></td>
  </tr>
</table>

#### nodejs::npm
<table>
  <tr>
    <th>Key</th>
    <th>Type</th>
    <th>Default</th>
  </tr>
  <tr>
    <td><tt>['nodejs']['global_packages']</tt></td>
    <td>Array</td>
    <td>
      <tt>
        [
          'grunt-cli',
          'grunt',
          'grunt-contrib-compress',
          'grunt-contrib-uglify',
          'grunt-contrib-cssmin'
        ]
      </tt>
    </td>
  </tr>
</table>
