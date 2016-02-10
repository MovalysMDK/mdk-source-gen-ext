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
package com.adeuza.movalysfwk.mf4mdd.mbandroid.extractors;

public enum MF4ATypes {

	//---------------------------------------
	// MF4A
	//---------------------------------------

	
	//---------------------------------------
	// MF4MJ
	//---------------------------------------
	BeanLoader("com.adeuza.movalysfwk.mobile.mf4mjcommons.core.services.BeanLoader"),
	CascadeSet("com.adeuza.movalysfwk.mobile.mf4mjcommons.core.beans.CascadeSet"),
	DaoException("com.adeuza.movalysfwk.mobile.mf4mjcommons.data.dao.DaoException"),
	MContext("com.adeuza.movalysfwk.mobile.mf4mjcommons.context.MContext"),	
	UpdatableFromDataloader("com.adeuza.movalysfwk.mobile.mf4mjcommons.ui.model.UpdatableFromDataloader"),
	SynchronisationResponseTreatmentInformation("com.adeuza.movalysfwk.mobile.mf4mjcommons.business.synchro.SynchronisationResponseTreatmentInformation"),
	ListenerOnMenuItemClick("com.adeuza.movalysfwk.mobile.mf4mjcommons.actiontask.listener.ListenerOnMenuItemClick"),

	//---------------------------------------
	// MF4J
	//---------------------------------------
	AbstractDataloader("com.adeuza.movalysfwk.mobile.mf4javacommons.dataloader.AbstractDataloader"),
	AbstractListDataloader("com.adeuza.movalysfwk.mobile.mf4javacommons.dataloader.AbstractListDataloader"),
	AbstractSynchronisableDataLoader("com.adeuza.movalysfwk.mobile.mf4javacommons.dataloader.AbstractSynchronisableDataLoader"),
	AbstractSynchronisableListDataloader("com.adeuza.movalysfwk.mobile.mf4javacommons.dataloader.AbstractSynchronisableListDataloader"),
	MMDataloader("com.adeuza.movalysfwk.mobile.mf4javacommons.dataloader.MMDataloader"),
	Dataloader("com.adeuza.movalysfwk.mobile.mf4javacommons.dataloader.Dataloader"),
	DataloaderException("com.adeuza.movalysfwk.mobile.mf4javacommons.dataloader.DataloaderException"),
	ListDataloader("com.adeuza.movalysfwk.mobile.mf4javacommons.dataloader.ListDataloader"),	
	SynchronisableDataLoader("com.adeuza.movalysfwk.mobile.mf4javacommons.dataloader.SynchronisableDataLoader"),
	SynchronisableListDataloader("com.adeuza.movalysfwk.mobile.mf4javacommons.dataloader.SynchronisableListDataloader"),
	DataloaderParts("com.adeuza.movalysfwk.mobile.mf4javacommons.dataloader.DataLoaderParts");
	
	
	
	/**
	 * 
	 */
	private String imp ;
	
	/**
	 * @param p_sImport
	 */
	private MF4ATypes( String p_sImport ) {
		this.imp = p_sImport ;
	}
	
	/**
	 * @return
	 */
	public String getImport() {
		return imp;
	}
}
