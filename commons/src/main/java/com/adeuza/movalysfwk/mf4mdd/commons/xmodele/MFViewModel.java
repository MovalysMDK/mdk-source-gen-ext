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
package com.adeuza.movalysfwk.mf4mdd.commons.xmodele;

import org.dom4j.Element;

import com.a2a.adjava.xmodele.MEntityImpl;
import com.a2a.adjava.xmodele.MPackage;
import com.a2a.adjava.xmodele.MViewModelImpl;
import com.a2a.adjava.xmodele.ui.viewmodel.ViewModelType;
import com.a2a.adjava.xmodele.ui.viewmodel.mappings.IVMMappingDesc;

/**
 * <p>TODO Décrire la classe MF4AViewModel</p>
 *
 * <p>Copyright (c) 2012
 * <p>Company: Adeuza
 *
 * @author emalespine
 *
 */

public class MFViewModel extends MViewModelImpl {
	
	/**
	 * 
	 */
	private MDataLoader dataLoader;
	
	/**
	 * Create a new view model.
	 * @param p_sName viewmodel name (including prefix/suffix)
	 * @param p_sUmlName uml name
	 * @param p_oPackage package of viewmodel
	 * @param p_sType viewmodel type
	 * @param p_oTypeEntityToUpdate entity to update
	 * @param p_sPathToModel path to model
	 * @param p_bCustomizable customizable
	 * @param p_oMapping mapping descriptor
	 */
	public MFViewModel(String p_sName, String p_sUmlName, MPackage p_oPackage, ViewModelType p_sType,
			MEntityImpl p_oEntityToUpdate, String p_sPath, boolean p_bCustomizable, IVMMappingDesc p_oMapping) {
		super(p_sName, p_sUmlName, p_oPackage, p_sType, p_oEntityToUpdate, p_sPath, p_bCustomizable, p_oMapping);
	}

	/**
	 * Get dataloader
	 * @return dataloader
	 */
	public MDataLoader getDataLoader() {
		return this.dataLoader;
	}

	/**
	 * Defines the DataLoader associated to this view model.
	 * @param p_oDataLoader
	 * @param le chemin pour avoir la donnée utile
	 */
	public void setDataLoader(MDataLoader p_oDataLoader) {
		this.dataLoader = p_oDataLoader;
	}

	/**
	 * (non-Javadoc)
	 * @see com.a2a.adjava.xmodele.MViewModelImpl#copyTo(com.a2a.adjava.xmodele.MViewModelImpl)
	 */
	@Override
	protected void copyTo(MViewModelImpl p_oViewModelImpl) {
		super.copyTo(p_oViewModelImpl);
		MFViewModel oMF4AViewModel = (MFViewModel) p_oViewModelImpl ;
		oMF4AViewModel.setDataLoader(this.dataLoader);
	}
	
	/**
	 * {@inheritDoc}
	 * @see com.a2a.adjava.xmodele.MViewModelImpl#toXml()
	 */
	@Override
	public Element toXml() {
		Element r_oXml = super.toXml();
		if (this.dataLoader != null) {
			r_oXml.add(this.dataLoader.toXml());
		}
		return r_oXml;
	}
}
