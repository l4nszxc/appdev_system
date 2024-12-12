// adminManageUsersController.js
const adminManageUsersModel = require('../models/adminManageUsersModel');

exports.getUsersByProgram = (req, res) => {
  const program = req.params.program;
  adminManageUsersModel.findUsersByProgram(program, (err, results) => {
    if (err) {
      console.error('Error fetching users:', err);
      return res.status(500).json({ message: 'An error occurred while fetching users' });
    }
    res.status(200).json(results);
  });
};