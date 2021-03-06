// Filename: clientDialDevice.I
// Created by:  drose (26Jan01)
//
////////////////////////////////////////////////////////////////////
//
// PANDA 3D SOFTWARE
// Copyright (c) Carnegie Mellon University.  All rights reserved.
//
// All use of this software is subject to the terms of the revised BSD
// license.  You should have received a copy of this license along
// with this source code in a file named "LICENSE."
//
////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////
//     Function: ClientDialDevice::DialState::Constructor
//       Access: Public
//  Description:
////////////////////////////////////////////////////////////////////
INLINE ClientDialDevice::DialState::
DialState() :
  _offset(0.0),
  _known(false)
{
}

////////////////////////////////////////////////////////////////////
//     Function: ClientDialDevice::Constructor
//       Access: Protected
//  Description:
////////////////////////////////////////////////////////////////////
INLINE ClientDialDevice::
ClientDialDevice(ClientBase *client, const string &device_name):
  ClientDevice(client, get_class_type(), device_name)
{
}

////////////////////////////////////////////////////////////////////
//     Function: ClientDialDevice::get_num_dials
//       Access: Public
//  Description: Returns the number of dial dials known to the
//               ClientDialDevice.  This number may change as
//               more dials are discovered.
////////////////////////////////////////////////////////////////////
INLINE int ClientDialDevice::
get_num_dials() const {
  return _dials.size();
}

////////////////////////////////////////////////////////////////////
//     Function: ClientDialDevice::push_dial
//       Access: Public
//  Description: Marks that the dial has been offset by the indicated
//               amount.  It is the user's responsibility to ensure
//               that this call is protected within acquire().
////////////////////////////////////////////////////////////////////
INLINE void ClientDialDevice::
push_dial(int index, double offset) {
  ensure_dial_index(index);
  nassertv(index >= 0 && index < (int)_dials.size());
  _dials[index]._offset += offset;
  _dials[index]._known = true;
}

////////////////////////////////////////////////////////////////////
//     Function: ClientDialDevice::read_dial
//       Access: Public
//  Description: Returns the number of complete revolutions of the
//               dial since the last time read_dial() was called.
//               This is a destructive operation; it is not possible
//               to read the dial without resetting the counter.
//
//               It is the user's responsibility to ensure that this
//               call is protected within acquire().
////////////////////////////////////////////////////////////////////
INLINE double ClientDialDevice::
read_dial(int index) {
  if (index >= 0 && index < (int)_dials.size()) {
    double result = _dials[index]._offset;
    _dials[index]._offset = 0.0;
    return result;
  } else {
    return 0.0;
  }
}

////////////////////////////////////////////////////////////////////
//     Function: ClientDialDevice::is_dial_known
//       Access: Public
//  Description: Returns true if the state of the indicated dial
//               dial is known, or false if we have never heard
//               anything about this particular dial.
////////////////////////////////////////////////////////////////////
INLINE bool ClientDialDevice::
is_dial_known(int index) const {
  if (index >= 0 && index < (int)_dials.size()) {
    return _dials[index]._known;
  } else {
    return false;
  }
}
