/**
 * Copyright (C) 2010 Sopra Steria Group (movalys.support@soprasteria.com)
 *
 * This file is part of Movalys MDK.
 * Movalys MDK is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 * Movalys MDK is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU Lesser General Public License for more details.
 * You should have received a copy of the GNU Lesser General Public License
 * along with Movalys MDK. If not, see <http://www.gnu.org/licenses/>.
 */
package com.adeuza.movalysfwk.mf4mdd.ios.extractor;

/**
 * MF4I Types
 * @author lmichenaud
 *
 */
public enum MF4ITypes {

	/**
	 * Label type
	 */
	MFLabel("MFLabel"),
	
	/**
	 * Detail form view controller type
	 */
	MFDetailFormViewController("MFFormDetailViewController"),
	
	/**
	 * Form view controller type
	 */
	MFFormViewController("MFFormViewController"),
	
	/**
	 * Search view controller type
	 */
	MFSearchViewController("MFSearchViewController"),
	
	/**
	 * List view controller type
	 */
	MFListViewController("MFFormListViewController"),
	
	/**
	 * 2D list view controller type
	 */
	MF2DListViewController("MFForm2DListViewController"),
	
	/**
	 * View controller type
	 */
	MFViewController("MFViewController")
	;
	
	/**
	 * Import
	 */
	private String imp ;
	
	/**
	 * Set import
	 * @param p_sImport import
	 */
	private MF4ITypes( String p_sImport ) {
		this.imp = p_sImport ;
	}
	
	/**
	 * Get import
	 * @return import
	 */
	public String getImport() {
		return this.imp;
	}
}
